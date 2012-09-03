Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756468Ab2ICNBT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Sep 2012 09:01:19 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45428 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754088Ab2ICNBR convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Sep 2012 09:01:17 -0400
From: Oliver Neukum <oneukum@suse.de>
To: Yann Cantin <yann.cantin@laposte.net>
Cc: linux-input@vger.kernel.org, linux-usb@vger.kernel.org,
        gregkh@linuxfoundation.org, dmitry.torokhov@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC ebeam PATCH v4 2/2] input: misc: New USB eBeam input driver.
Date: Mon, 03 Sep 2012 14:59:58 +0200
Message-ID: <1816600.0kCAv4ld5c@linux-lqwf.site>
Organization: SUSE
User-Agent: KMail/4.8.4 (Linux/3.6.0-rc2-12-desktop+; KDE/4.8.5; x86_64; ; )
In-Reply-To: <503792CC.6050209@laposte.net>
References: <1345673514-11575-1-git-send-email-yann.cantin@laposte.net> <1555763.Oi7gGGn7BU@linux-lqwf.site> <503792CC.6050209@laposte.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="iso-8859-1"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 24 August 2012 16:42:20 Yann Cantin wrote:
> Hi,
> 
> Le 24/08/2012 13:41, Oliver Neukum a écrit :
> > On Friday 24 August 2012 11:37:45 Yann Cantin wrote:
> >> Hi,
> >>
> >> Le 23/08/2012 09:23, Oliver Neukum a écrit :
> >>> On Thursday 23 August 2012 00:11:54 Yann Cantin wrote:
> > 
> >>> These functions are identical. You should unify them.
> >>
> >> Removed reset_resume from the driver (optional, and not needed
> >> for this hardware).
> > 
> > Why did you do that? It is always better to have reset_resume().
> > And you cannot tell whether it will be needed.
> 
> This function was used in usbtouchscreen (which this driver is based on)
> for some hardware specific init after reset. eBeam devices doesn't need that,
> and i didn't mention the similarity of the 2 functions after stripping the code.
> 
> According to power-management.txt, reset_resume is optional, and lot of input
> driver lack it. Anyway, if you think it's worth the code, i'll re-add a 
> reset_resume function proxing resume like wacom_sys.c do.

It is always better to have reset_resume() if it can be easily done.

	Regards
		Oliver

