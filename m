Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751868Ab1KSHUY (ORCPT <rfc822;w@1wt.eu>);
	Sat, 19 Nov 2011 02:20:24 -0500
Received: from bay0-omc1-s6.bay0.hotmail.com ([65.54.190.17]:57913 "EHLO
	bay0-omc1-s6.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751024Ab1KSHUX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 19 Nov 2011 02:20:23 -0500
X-Greylist: delayed 370 seconds by postgrey-1.27 at vger.kernel.org; Sat, 19 Nov 2011 02:20:23 EST
Message-ID: <BAY156-W333AEB3C478890404DB815A3C50@phx.gbl>
X-Originating-IP: [76.190.155.50]
From: =?utf-8?B?5bCP6b6ZIOmZiA==?= <chillermillerlong@hotmail.com>
To: <linux-kernel@vger.kernel.org>
Subject: thinkpad_acpi does not generate correct ACPI events when
 brightness_enable=0
Date: Sat, 19 Nov 2011 02:14:12 -0500
Importance: Normal
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
X-OriginalArrivalTime: 19 Nov 2011 07:14:12.0703 (UTC) FILETIME=[D6D73EF0:01CCA68A]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by nfs id pAJ7KY59015551


Hi!
I'm having a problem with the thinkpad_acpi kernel module where it does notgenerate a brightness down ACPI event when the "brightness_enable=0" parameteris set. This only happens when the module is automatically loaded at boot andafter resume from suspend.
Everything is fine once I run:
Â  rmmod thinkpad_acpiÂ  modprobe thinkpad_acpi brightness_enable=0
The "acpi_listen" command shows this following when either the brightness up orbrightness down button is pressed:
Â  ibm/hotkey LEN0068:00 00000080 00006050
and also the following when the brightness up button is pressed:
Â  video/brightnessup BRTUP 00000086 00000000
The following brightness down ACPI event is only generated after the module isreloaded:
Â  video/brightnessdown BRTDN 00000087 00000000
Is this a known bug (or even a bug at all)? The kernel bugzilla is down.
Also, I apologize if the kernel mailing list is the wrong place to post this.If this belongs somewhere else, I'd appreciate it if someone told me where.
Regards,Xiao-Long Chen 		 	   		  ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
