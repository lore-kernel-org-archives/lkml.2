Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933717Ab1J2Rr6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Oct 2011 13:47:58 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:53595 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933496Ab1J2Rr5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Oct 2011 13:47:57 -0400
Message-ID: <4EAC3C5C.5000209@lwfinger.net>
Date: Sat, 29 Oct 2011 12:48:12 -0500
From: Larry Finger <Larry.Finger@lwfinger.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: USB list <linux-usb@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        v4mp <gaigo88@hotmail.it>
Subject: Question about error from xhci-hcd
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sarah,

Pardon the intrusion, but I'm trying to fix a problem for v4mp, a user of the 
rtl8192cu driver on an Alfa AWUS036NHR. I have one of the devices, and it works 
on a USB 2.0 hub, but fails with 3.0 hardware with lots of

xhci_hcd 0000:05:00.0: ERROR no room on ep ring

messages logged.

The device works with an out-of-kernel driver available from the Alfa or Realtek 
web sites, but I want to fix rtl8192cu.

What condition leads to the above message? The user's dmesg buffer has wrapped, 
thus I don't see the beginning of the failure. He is using a canned distro 
kernel, thus he cannot include any extra debugging info such as a stack dump 
when the errors occur. As he uses the compat-wireless package, I think I can 
incorporate a new copy of xhci-hcd with it, but I have not done so yet.

Thanks for any help you can give,

Larry

