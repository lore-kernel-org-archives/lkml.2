Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757261Ab1CRTdQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 15:33:16 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:52518 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756739Ab1CRTdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 15:33:09 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Justin Piszcz <jpiszcz@lucidpixels.com>
Subject: Re: 2.6.38: XFS/USB/HW issue, or failing USB stick?
Date: Fri, 18 Mar 2011 20:33:02 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38-rc8+; KDE/4.5.1; x86_64; ; )
Cc: Tim Soderstrom <tim@moocowproductions.org>, linux-usb@vger.kernel.org,
        xfs@oss.sgi.com, linux-kernel@vger.kernel.org,
        Alan Piszcz <ap@solarrain.com>, flashbench-results@lists.linaro.org
References: <alpine.DEB.2.02.1103181104020.30018@p34.internal.lan> <201103182010.37455.arnd@arndb.de> <alpine.DEB.2.02.1103181524400.21715@p34.internal.lan>
In-Reply-To: <alpine.DEB.2.02.1103181524400.21715@p34.internal.lan>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103182033.02793.arnd@arndb.de>
X-Provags-ID: V02:K0:qRZhx1/MvMNAMNOqzu24f28NDf3lhYLp35EJqN8D8hT
 KDVODHPjteNn990G9iPD004yVyeoPhDy9gjsudUqGS/jwZe9ZH
 B/KAXCvtfwJdQgeIttDESDCmeMkuQ3BrHqowjKBEewmZ0skcd/
 BxJaAe2Lt3l8am/ySJmb9E1RG8s3UjrL5Dq7IIXW7UEeB1d46e
 rNU0sWJ9O5cnwoi9V5PHw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 18 March 2011 20:26:46 Justin Piszcz wrote:
> > The numbers are jumping around a bit with the incorrectly guessed erasesize.
> > These values should be more like the ones in the first test. Can you rerun
> > with --erasesize=$[4 * 1024 * 1024]?
> Hi, I put the box back into production with ext2, if it fails again I can 
> re-run.

Ok. Did you make sure to get the partition table right? It's
rather tricky with fdisk, since it normally doesn't align
to 4 MB. You can see this using 'fdisk -l -u /dev/sda'.

> > Also, what is the output of 'lsusb' for this stick? I'd like to add the
> > data to https://wiki.linaro.org/WorkingGroups/KernelConsolidation/Projects/FlashCardSurvey
> Sure,
> Bus 001 Device 002: ID 0325:ac02 OCZ Technology Inc ATV Turbo / Rally2 Dual Channel USB 2.0 Flash Drive
> 

Added now, thanks!

Do you also have the product name for this?

	Arnd
