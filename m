Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542Ab0KKSow (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 13:44:52 -0500
Received: from ppsw-50.csi.cam.ac.uk ([131.111.8.150]:54993 "EHLO
	ppsw-50.csi.cam.ac.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752618Ab0KKSov (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 13:44:51 -0500
X-Greylist: delayed 1121 seconds by postgrey-1.27 at vger.kernel.org; Thu, 11 Nov 2010 13:44:51 EST
X-Cam-AntiVirus: no malware found
X-Cam-SpamDetails: not scanned
X-Cam-ScannerInfo: http://www.cam.ac.uk/cs/email/scanner/
Date: Thu, 11 Nov 2010 18:26:06 +0000
From: Tony Finch <dot@dotat.at>
X-X-Sender: fanf2@hermes-2.csi.cam.ac.uk
To: Randy Dunlap <randy.dunlap@oracle.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>, Tony Finch <dot@dotat.at>
Subject: Re: linux-next: Tree for November 11 (unifdef)
In-Reply-To: <20101111094832.827aaab3.randy.dunlap@oracle.com>
Message-ID: <alpine.LSU.2.00.1011111820460.8553@hermes-2.csi.cam.ac.uk>
References: <20101111125655.15fa7188.sfr@canb.auug.org.au> <20101111094832.827aaab3.randy.dunlap@oracle.com>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 11 Nov 2010, Randy Dunlap wrote:
>
> Is this a problem with privcmd.h or unifdef or ???

It's a problem with ???, specifically

scripts/headers_install.pl:33:    $line =~ s/([\s(])__user\s/$1/g;

There are a few other files which have the same idiom which potentially
breaks headers_install

drivers/staging/ath6kl/os/linux/include/ar6000_drv.h
drivers/video/sis/sis_main.c
drivers/video/via/ioctl.h

Tony.
-- 
f.anthony.n.finch  <dot@dotat.at>  http://dotat.at/
HUMBER THAMES DOVER WIGHT PORTLAND: NORTH BACKING WEST OR NORTHWEST, 5 TO 7,
DECREASING 4 OR 5, OCCASIONALLY 6 LATER IN HUMBER AND THAMES. MODERATE OR
ROUGH. RAIN THEN FAIR. GOOD.
