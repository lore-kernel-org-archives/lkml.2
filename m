Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754048Ab0JGW4h (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 18:56:37 -0400
Received: from asmtpout024.mac.com ([17.148.16.99]:55285 "EHLO
	asmtpout024.mac.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750992Ab0JGW4g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 18:56:36 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: text/plain; CHARSET=US-ASCII
X-Proofpoint-Virus-Version: vendor=fsecure
 engine=2.50.10432:5.2.15,1.0.148,0.0.0000
 definitions=2010-10-07_09:2010-10-07,2010-10-07,1970-01-01 signatures=0
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0
 ipscore=0 suspectscore=5 phishscore=0 bulkscore=0 adultscore=0 classifier=spam
 adjust=0 reason=mlx engine=6.0.2-1004200000 definitions=main-1010070154
Subject: Re: kgdb errors with serial console
From: Elvis Dowson <elvis.dowson@mac.com>
In-reply-to: <4CAE4BB6.7080509@windriver.com>
Date: Fri, 08 Oct 2010 02:55:50 +0400
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux OMAP Mailing List <linux-omap@vger.kernel.org>
Message-id: <0586B1CE-68E7-4182-AC9C-516B71BF5FB7@mac.com>
References: <BDD07355-7199-4A2E-8426-F6D43EA5D313@mac.com>
 <4CAE4BB6.7080509@windriver.com>
To: Jason Wessel <jason.wessel@windriver.com>
X-Mailer: Apple Mail (2.1081)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jason,

On Oct 8, 2010, at 2:37 AM, Jason Wessel wrote:
> 
> Looks to me like you did not activate the kernel debugger before using
> gdb to enter, because the gdb you are using is not going to send the
> "sysrq g" sequence.

Will it not be activated and wait with the following boot args?

mmcargs=setenv bootargs console=${console} vram=12M omapfb.vram=0:4M omapfb.mode=dvi:${dvimode} omapdss.def_disp=${defaultdisplay} root=/dev/mmcblk0p2 rw rootfstype=ext3 rootwait kgdb=${console} kgdboc=${console} kgdbwait

After specific the following commands in .gdbinit, I am able to get properly formatted messages in the Eclipse IDE

set remotebaud 115200
set remoteflow 0
set debug remote 1

Best regards,

Elvis
