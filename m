Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755616Ab1JWOSZ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Oct 2011 10:18:25 -0400
Received: from mx1.redhat.com ([209.132.183.28]:30768 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755567Ab1JWOSY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Oct 2011 10:18:24 -0400
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Greg KH <greg@kroah.com>, Piotr Hosowicz <piotr@hosowicz.com>,
        linux-kernel@vger.kernel.org, John Hawley <warthog19@gmail.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: Linux 3.0.7 now on kernel.org
References: <20111023083131.GA13802@kroah.com> <4EA40795.3070603@example.com>
	<20111023122927.GB25711@kroah.com> <4EA4151A.4030605@zytor.com>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Sun, 23 Oct 2011 10:18:17 -0400
In-Reply-To: <4EA4151A.4030605@zytor.com> (H. Peter Anvin's message of "Sun, 23 Oct 2011 15:22:34 +0200")
Message-ID: <y0mmxcrx046.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"H. Peter Anvin" <hpa@zytor.com> writes:

> [...]
> Signing the compressed file makes the compression "precious".  It also
> means that the developer has to sign each.
>
> It's not significantly "more handy" either... you can do something like:
> 	xz -cd file.xz | gpg --verify file.sign -

On the other hand, it forces someone to decompress an untrustworthy
file in order to check its signature.  Should there ever be a security
exploit in any of these decompressors, this practice would aid
triggering it.

- FChE
