Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755534Ab1FFLZ0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jun 2011 07:25:26 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:43270 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753035Ab1FFLZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jun 2011 07:25:26 -0400
X-Authenticated: #28250155
X-Provags-ID: V01U2FsdGVkX1/tbbhAU37t/YOF63zRmCfadlsup8Z5uAYbH+wVqN
	fOH/bpK9dQxmLL
From: Sven Joachim <svenjoac@gmx.de>
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc2
References: <BANLkTinrbh7Xi27an3uY7pDWrNKhJRYmEA@mail.gmail.com>
	<BANLkTik-xtEnf8Bxz3PmP6H+YYSDXe1adw@mail.gmail.com>
	<BANLkTimDu8YAb1uOMDqVLSX86=hZeyoAgA@mail.gmail.com>
Date: Mon, 06 Jun 2011 13:25:17 +0200
In-Reply-To: <BANLkTimDu8YAb1uOMDqVLSX86=hZeyoAgA@mail.gmail.com> (Alessandro
	Suardi's message of "Mon, 6 Jun 2011 12:36:30 +0200")
Message-ID: <87fwnndwwy.fsf@turtle.gmx.de>
User-Agent: Gnus/5.110017 (No Gnus v0.17) Emacs/23.3.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2011-06-06 12:36 +0200, Alessandro Suardi wrote:

> On Mon, Jun 6, 2011 at 12:27 PM, Alessandro Suardi
>>
>> 3.0-rc2 tarball appeared, but patch-3.0-rc2.bz2/gz hasn't yet,
>>  at least according to the proxy server I'm currently behind.
>
> Actually I'm not so sure what I said is true: 3.0-rc2.tar.gz appeared, but
>  it's too small, at 15MB vs the 92MB of -rc1...
>
> And I can't tell what's inside, as the helpful antivirus product within the
>  proxy quits due to too many files in the tarball I'm attempting to download.

I downloaded it but can't tell what's inside either:

,----
| $ tar xf linux-3.0-rc2.tar.gz 
| 
| gzip: stdin: unexpected end of file
| tar: Unexpected EOF in archive
| tar: Unexpected EOF in archive
| tar: Error is not recoverable: exiting now
`----

Maybe an ENOSPC problem on the host that generated the tarball?

Cheers,
       Sven
