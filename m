Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752542Ab1HORoC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 13:44:02 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:42833 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752238Ab1HORoA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 13:44:00 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Peter =?iso-8859-2?q?H=FCwe?= <PeterHuewe@gmx.de>
Subject: Re: [PATCH] shmobile/sh7372: Add missing CONFIG_PM guards to fix build failure
Date: Mon, 15 Aug 2011 19:45:41 +0200
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc2+; KDE/4.6.0; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1313274841-8322-1-git-send-email-peterhuewe@gmx.de> <201108140155.05625.rjw@sisk.pl> <201108151630.12120.PeterHuewe@gmx.de>
In-Reply-To: <201108151630.12120.PeterHuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 8BIT
Message-Id: <201108151945.42155.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 15, 2011, Peter Hüwe wrote:
> Am Sonntag 14 August 2011, 01:55:05 schrieb Rafael J. Wysocki:
> > On Sunday, August 14, 2011, Peter Huewe wrote:
> > > This patch fixes a build failure with the ap4evb_defconfig by adding the
> > > missing #ifdef CONFIG_PM.
> > 
> > This is not the right fix.  Besides, you seem to be testing linux-next
> > and the build problem is in the linux-pm tree.
> > 
> > Please check if the appended patch fixes the problem for you.
> > 
> > Rafael
> Works for me - compiles ;)
> 
> Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

Good, thanks for testing!

I have folded the fix into the patch that caused the problem, so this
should be fixed in linux-next now.

Thanks,
Rafael
