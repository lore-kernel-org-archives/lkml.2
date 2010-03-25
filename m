Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753417Ab0CYMfU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Mar 2010 08:35:20 -0400
Received: from lucidpixels.com ([75.144.35.66]:34379 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751983Ab0CYMfS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Mar 2010 08:35:18 -0400
Date: Thu, 25 Mar 2010 08:35:17 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
       xorg@lists.freedesktop.org
cc: Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <alpine.DEB.2.00.1003250800200.13307@p34.internal.lan>
Message-ID: <alpine.DEB.2.00.1003250833040.13307@p34.internal.lan>
References: <alpine.DEB.2.00.1003250800200.13307@p34.internal.lan>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 25 Mar 2010, Justin Piszcz wrote:

The same problem has been reported by another person, he says his entire 
system freezes, which, it appears to do unless you can SSH into the box:
http://www.openoffice.org/issues/show_bug.cgi?id=76797

Look at his lspci listing.
james@dv6105us:~$ lspci
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)

Here is mine:
$ lspci
00:00.0 RAM memory: nVidia Corporation C51 Host Bridge (rev a2)
00:00.1 RAM memory: nVidia Corporation C51 Memory Controller 0 (rev a2)
00:00.2 RAM memory: nVidia Corporation C51 Memory Controller 1 (rev a2)
00:00.3 RAM memory: nVidia Corporation C51 Memory Controller 5 (rev a2)

Looks like the bug may be in the USB subsystem for this chipset.

Justin.

