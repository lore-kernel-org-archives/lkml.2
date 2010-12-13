Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754176Ab0LMINX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Dec 2010 03:13:23 -0500
Received: from smtpeu1.atmel.com ([195.65.72.27]:50777 "EHLO bagnes.atmel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751534Ab0LMINW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Dec 2010 03:13:22 -0500
Subject: Re: [PATCH v2] avr32: Fix build failure conflicting types for
 'sys_execve'
From: Hans-Christian Egtvedt <hans-christian.egtvedt@atmel.com>
To: Peter =?ISO-8859-1?Q?H=FCwe?= <PeterHuewe@gmx.de>
Cc: "David S. Miller" <davem@davemloft.net>,
        David Howells <dhowells@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        stable@kernel.org
In-Reply-To: <201012122037.59016.PeterHuewe@gmx.de>
References: <20101209182132.GB24175@kroah.com>
	 <1291929328-30551-1-git-send-email-peterhuewe@gmx.de>
	 <1291976741.18008.37.camel@hcegtvedt>
	 <201012122037.59016.PeterHuewe@gmx.de>
Content-Type: text/plain; charset="UTF-8"
Organization: Atmel Corporation
Date: Mon, 13 Dec 2010 09:12:53 +0100
Message-ID: <1292227973.18008.53.camel@hcegtvedt>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 8BIT
X-OriginalArrivalTime: 13 Dec 2010 08:12:57.0703 (UTC) FILETIME=[8D0ACF70:01CB9A9D]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2010-12-12 at 20:37 +0100, Peter Hüwe wrote: 
> Am Freitag 10 Dezember 2010, 11:25:41 schrieb Hans-Christian Egtvedt:
> > Nack, I've piped up a patch in
> > http://git.kernel.org/?p=linux/kernel/git/egtvedt/avr32-2.6.git;a=shortlog;
> > h=refs/heads/next that does this and more. The syscalls.h header file needs
> > a bit more cleanup.
> > 
> > I'll also notify stable to get it backported. Do you have an idea how
> > far back it should go?
> 
> Hi,
> 
> Linus' tree fails since August 19th due to this issue, so it falls into the 
> 2.6.36 merge window only.
> http://kisskb.ellerman.id.au/kisskb/buildresult/3059836/

Thanks for digging that up. The patch will only need to be applied to
v2.6.36 and beyond then.

> (but it still failed for quite a while longer due to other issues ;)

What other issues?

> Thanks,
> Peter
> (a reported by on the patch would have been nice ;)

Of course, I'll rebase and add you're name to it. Does the same go for
David Howells?

-- 
Hans-Christian Egtvedt

