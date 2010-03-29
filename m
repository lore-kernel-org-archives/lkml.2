Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753500Ab0C2SoR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Mar 2010 14:44:17 -0400
Received: from lucidpixels.com ([75.144.35.66]:56785 "EHLO lucidpixels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753438Ab0C2SoN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Mar 2010 14:44:13 -0400
Date: Mon, 29 Mar 2010 14:44:11 -0400 (EDT)
From: Justin Piszcz <jpiszcz@lucidpixels.com>
To: Alan Stern <stern@rowland.harvard.edu>
cc: Kernel development list <linux-kernel@vger.kernel.org>,
       USB list <linux-usb@vger.kernel.org>, Alan Piszcz <ap@solarrain.com>
Subject: Re: 2.6.33: Xorg+khubd lockup (D-state) BUG / ioctl EVIOCGNAME
 failed: Inappropriate ioctl for device / PreInit returned NULL
In-Reply-To: <Pine.LNX.4.44L0.1003291253410.3358-100000@iolanthe.rowland.org>
Message-ID: <alpine.DEB.2.00.1003291443330.10153@p34.internal.lan>
References: <Pine.LNX.4.44L0.1003291253410.3358-100000@iolanthe.rowland.org>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Mon, 29 Mar 2010, Alan Stern wrote:

> On Mon, 29 Mar 2010, Justin Piszcz wrote:
>
> Yes it does.  Maybe there's something wrong with the way your email
> client extracted the patch from the message.
You're correct, sorry about that, when it recurs and I have the usbmon
trace output I will send it along.

>
>> It also fails against 2.6.34-rc2, can you diff -u and show the patch so
>> I can patch manually or include a patch against 2.6.33 or 2.6.34-rc2?
>
> That _was_ a "diff -u"-style patch.
>
> Alan Stern
>
