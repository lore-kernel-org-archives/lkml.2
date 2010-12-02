Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755753Ab0LBAyg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 19:54:36 -0500
Received: from xenotime.net ([72.52.115.56]:41583 "HELO xenotime.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1753581Ab0LBAyf convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 19:54:35 -0500
Date: Wed, 1 Dec 2010 16:54:32 -0800
From: Randy Dunlap <rdunlap@xenotime.net>
To: Toralf =?ISO-8859-1?Q?F=F6rster?= <toralf.foerster@gmx.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: kernel: firmware[13353]: segfault
Message-Id: <20101201165432.99294f48.rdunlap@xenotime.net>
In-Reply-To: <201011261015.52704.toralf.foerster@gmx.de>
References: <201011261015.52704.toralf.foerster@gmx.de>
Organization: YPO4
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 26 Nov 2010 10:15:52 +0100 Toralf Förster wrote:

> I'm wondering whom to blame wrt to this issue : 
> http://sourceware.org/bugzilla/show_bug.cgi?id=12268


Choose from usb, media/dvb, or udev/hotplug:

2010-11-25T22:04:52.244+01:00 n22 kernel: firmware[13353]: segfault at 46 ip
b7769597 sp bf9158a0 error 4 in libc-2.11.2.so[b770e000+13f000]
2010-11-25T22:04:52.000+01:00 n22 udevd-work[13350]: 'firmware
--firmware=dvb-usb-dib0700-1.20.fw
--devpath=/devices/pci0000:00/0000:00:1a.7/usb1/1-1/firmware/1-1' unexpected
exit with status 0x000b


I think I'd begin with udev (linux-hotplug mailing list).


---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
