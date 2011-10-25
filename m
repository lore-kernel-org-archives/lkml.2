Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755241Ab1JYI10 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Oct 2011 04:27:26 -0400
Received: from terminus.zytor.com ([198.137.202.10]:50478 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754589Ab1JYI1Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Oct 2011 04:27:24 -0400
Message-ID: <4EA672D9.106@zytor.com>
Date: Tue, 25 Oct 2011 10:27:05 +0200
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Kyle Moffett <kyle@moffetthome.net>
CC: Greg KH <greg@kroah.com>, Jari Ruusu <jariruusu@users.sourceforge.net>,
        linux-kernel@vger.kernel.org
Subject: Re: kernel.org tarball/patch signature files
References: <4EA3F7C0.24E469C5@users.sourceforge.net> <20111023113727.GA24285@kroah.com> <4EA41FB7.CB5369CF@users.sourceforge.net> <20111025014911.GC22764@kroah.com> <CAGZ=bqKvb96VvZ5a+VJWZXKdr553n8SW2=JOLZS1fGY5KE7iZg@mail.gmail.com>
In-Reply-To: <CAGZ=bqKvb96VvZ5a+VJWZXKdr553n8SW2=JOLZS1fGY5KE7iZg@mail.gmail.com>
X-Enigmail-Version: 1.3.2
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/25/2011 06:31 AM, Kyle Moffett wrote:
> 
> Unfortunately, while there are "pristine-gz" and "pristine-bz2" tools,
> there has not yet been developed a "pristine-xz" tool:
>   http://bugs.debian.org/cgi-bin/bugreport.cgi?bug=499489
> 
> So it's not yet reasonably possible for the kernel.org archive, but
> sometime in the future it might become so.
> 

There are a lot of strong reasons to NOT do so, however.

Any time we have something signed by a developer, we have something that
is precious and cannot be replicated by kernel.org staff.

Any time we have something signed by a robot, we have something that
people *will* misinterpret as having security properties that they don't
-- this has unfortunately been amply shown.

Compression formats evolve over time; right now we're concerned with gz,
bz2, and xz, but xz is brand new here and there may very well be new
things in the future.

It would be a very good thing for people to develop tools to run
compressors and decompressors in locked-down boxes.  It should be
possible to run these kinds of programs without access to either network
or filesystem; only read from stdin and out on stdout (and presumably
stderr for errors.)  This would solve problems for much more than just
kernel.org.

	-hpa

