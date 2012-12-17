Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751617Ab2LQHj1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Dec 2012 02:39:27 -0500
Received: from mail.snarked.org ([67.43.172.250]:1275 "EHLO mail.snarked.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750813Ab2LQHj0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Dec 2012 02:39:26 -0500
X-Greylist: delayed 932 seconds by postgrey-1.27 at vger.kernel.org; Mon, 17 Dec 2012 02:39:26 EST
X-Envelope-From: <newsserv> (mail.snarked.org)
To: linux-kernel@vger.kernel.org
From: "D. Stussy" <spam+newsgroups@bde-arc.ampr.org>
Newsgroups: linux.kernel
Subject: Help or bug?  RTL8192CU driver.
Date: Sun, 16 Dec 2012 23:24:19 -0800
Message-ID: <kamhai$a0r$1@snarked.org>
Reply-To: "D. Stussy" <replies+newsgroups@kd6lvw.ampr.org>
NNTP-Posting-Host: mdt.bde-arc.ampr.org
Mime-Version: 1.0
Content-Type: text/plain;
	format=flowed;
	charset="utf-8";
	reply-type=original
Content-Transfer-Encoding: 7bit
X-Trace: snarked.org 1355729042 10267 2001:470:d:468:7455:7a:1c17:3db4 (17 Dec 2012 07:24:02 GMT)
X-Complaints-To: newsmaster+complaints@snarked.org
NNTP-Posting-Date: Mon, 17 Dec 2012 07:24:02 +0000 (UTC)
X-No-Archive: Yes
X-MimeOLE: Produced By Microsoft MimeOLE V15.4.3555.308
X-Newsreader: Microsoft Windows Live Mail 15.4.3555.308
Importance: Normal
X-Priority: 3
X-MSMail-Priority: Normal
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I am having trouble with using the RTL8192CU 802.11n USB network chip.  I have 
verified that I have the correct firmware (the size is 16014 bytes and the MD5 
signature matches the one posted in various forums as correct).  The kernel 
tries to load it, but after about 20 seconds, a message indicating that it was 
not available appears in my kernel log.  No other reason is given.

As the problem occurs on a x86-64-bit system, is there a problem with loading 
firmware into the device on those systems?  Or might I have a buggy network 
device?


USB:  Bus 001 Device 003: ID 0bda:8176 Realtek Semiconductor Corp. RTL8188CUS 
802.11n WLAN

syslog/dmesg:
cfg80211: Calling CRDA to update world regulatory domain
rtl8192cu 1-2:1.0: usb_probe_interface
rtl8192cu 1-2:1.0: usb_probe_interface - got id
rtl8192cu: Chip version 0x10
rtl8192cu: MAC address: 48:02:2a:8f:de:0b
rtl8192cu: Board Type 0
rtlwifi: rx_max_size 15360, rx_urb_num 8, in_ep 1

...  [regulatory messages indicating available frequencies] ...

rtl8192cu: Loading firmware rtlwifi/rtl8192cufw.bin
cfg80211: Pending regulatory request, waiting for it to be processed...
usbcore: registered new interface driver rtl8192cu
   [pause for about 20 seconds]
rtlwifi: Firmware rtlwifi/rtl8192cufw.bin not available

Yet, the file is there:
-rw-r--r-- 2 root root 16014 Apr  1  2012 /lib/firmware/rtlwifi/rtl8192cufw.bin

What else should I look for or do?


