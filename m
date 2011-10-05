Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935042Ab1JEQnQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Oct 2011 12:43:16 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47256 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934922Ab1JEQnP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Oct 2011 12:43:15 -0400
Date: Wed, 5 Oct 2011 12:43:06 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Manoj Iyer <manoj.iyer@canonical.com>
Cc: Chris Ball <cjb@laptop.org>, Koji Matsumuro <matsumur@nts.ricoh.co.jp>,
        Jesse Barnes <jbarnes@virtuousgeek.org>, stable@kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mmc: Always check for lower base frequency quirk for
 Ricoh 1180:e823
Message-ID: <20111005164306.GC2479@zod.bos.redhat.com>
References: <20111005154449.GA2479@zod.bos.redhat.com>
 <alpine.DEB.2.02.1110051059550.3478@sleepy>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.02.1110051059550.3478@sleepy>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 05, 2011 at 11:27:01AM -0500, Manoj Iyer wrote:
> On Wed, 5 Oct 2011, Josh Boyer wrote:
> 
> >Commit 15bed0f2f added a quirk for the e823 Ricoh card reader to lower the
> >base frequency.  However, the quirk first checks to see if the proprietary
> >MMC controller is disabled, and returns if so.  On some devices, such as the
> >Lenovo X220, the MMC controller is already disabled by firmware it seems,
> 
> It is possible that the newer firmware from Lenovo disables the MMC
> controller. When the patch was done, these laptops had just been
> announced, so they had a very early version of the firmware (ver
> 1.02 iirc).

Seems so.  The X220 laptop I debugged this on shows:

[jwboyer@zod linux-2.6]$ cat /sys/devices/virtual/dmi/id/bios_version 
8DET42WW (1.12 )

josh
