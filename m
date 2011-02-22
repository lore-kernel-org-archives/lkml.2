Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939Ab1BVCGM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Feb 2011 21:06:12 -0500
Received: from mail001.aei.ca ([206.123.6.130]:43971 "EHLO mail001.aei.ca"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750920Ab1BVCGL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Feb 2011 21:06:11 -0500
From: Ed Tomlinson <edt@aei.ca>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [Bug #28562] [BUG] usb problems in .38-rc3+
Date: Mon, 21 Feb 2011 21:06:06 -0500
User-Agent: KMail/1.13.6 (Linux/2.6.38-rc5-crc+; KDE/4.6.0; x86_64; ; )
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>
References: <xmAo3o4v0VF.A.eLH.HWtYNB@chimera> <5HY1m9_-mkI.A.VxH.8WtYNB@chimera>
In-Reply-To: <5HY1m9_-mkI.A.VxH.8WtYNB@chimera>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201102212106.07392.edt@aei.ca>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 21 February 2011 17:03:00 Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
> 
> The following bug entry is on the current list of known regressions
> from 2.6.37.  Please verify if it still should be listed and let the tracking team
> know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=28562
> Subject		: [BUG] usb problems in .38-rc3+
> Submitter	: Ed Tomlinson <edt@aei.ca>
> Date		: 2011-02-05 19:17 (17 days old)
> Message-ID	: <201102051417.58953.edt@aei.ca>
> References	: http://marc.info/?l=linux-kernel&m=129693391417607&w=2
 
I figured out a work around for this.  Once the bluetooth adaptor has been detected and udev
had done its stuff run: 

hciconfig -a

With this user space change it works.  I have no idea why the 'hciconfig -a' query fixes things.
I run gentoo and bluez-4.87 is installed.

Ed Tomlinson
