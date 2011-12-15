Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758908Ab1LOPUD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Dec 2011 10:20:03 -0500
Received: from mail01.manz-automation.com ([88.79.234.227]:14917 "EHLO
	mail01.manz-automation.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751544Ab1LOPUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Dec 2011 10:20:02 -0500
Message-ID: <1323962398.11872.3.camel@raz>
Subject: Re: Subject:[PATCH 1:1] boot paramer "root=" gets a list of devices
From: Raz Ben Yehuda <rbenyehuda@manz.com>
Reply-To: <rbenyehuda@manz.com>
To: "H. Peter Anvin" <hpa@zytor.com>
CC: "wad@chromium.org" <wad@chromium.org>,
        "kay.sievers@vrfy.org" <kay.sievers@vrfy.org>,
        Rasty Slutsker <RSlutsker@manz.com>, Lior Brafman <LBrafman@manz.com>,
        <raziebe@gmail.com>, <linux-kernel@vger.kernel.org>
Date: Thu, 15 Dec 2011 17:19:58 +0200
In-Reply-To: <4EEA0C05.4030907@zytor.com>
References: <1323940396.16032.2.camel@raz> <4EEA0C05.4030907@zytor.com>
Organization: Manz
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.1- 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-12-15 at 16:02 +0100, H. Peter Anvin wrote:
> On 12/15/2011 01:13 AM, Raz Ben Yehuda wrote:
> > From: Raz ben yehuda<rbenyehuda@manz.com>
> >
> > Patch is aimed to bypass the need for initramfs when it is not
> > known which disk has the root file system.
> >
> > Example: The kernel boot parameter "root=/dev/sda1,/dev/sdc1,/dev/sdb4".
> > Check if /dev/sda1 exists ,if /dev/sda1 does not exist then try
> > /dev/sdc1 an so on upto the first a device that exists ( ROOT_DEV != 0 ),
> > else use the last device as the mount device.
> >
> > patch is on top of 3.2-rc5.
> >
> > Signed-off-by: Raz Ben Yehuda<rbenyehuda@manz.com>
> >
> 
> To which point I have to ask, once again, at which point we stop putting 
> this stuff in the kernel to "bypass the need for initramfs"...
because there are times where we cannot use initramfs. is this a problem
with way i phrase or with with the whole idea ?  

> 	-hpa


