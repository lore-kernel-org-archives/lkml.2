Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755195Ab2ADKFC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 05:05:02 -0500
Received: from victor.provo.novell.com ([137.65.250.26]:36141 "EHLO
	victor.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754880Ab2ADKFA (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:0:0>);
	Wed, 4 Jan 2012 05:05:00 -0500
Subject: Re: hp-wmi: disabling Bluetooth also kills WiFi
From: joeyli <jlee@suse.com>
To: Milan Bouchet-Valat <nalimilan@club.fr>
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1325670091.2354.6.camel@milan>
References: <1325670091.2354.6.camel@milan>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Jan 2012 18:01:24 +0800
Message-ID: <1325671284.11584.126.camel@linux-s257.site>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.2 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Milan, 

於 三，2012-01-04 於 10:41 +0100，Milan Bouchet-Valat 提到：
> Hi!
> 
> (I asked before on linux-bluetooth, but I was said hp-wmi developers
> didn't hang there... Hope this is the right place.)
> 
> With kernels 3.1 and 3.2rc7, disabling Bluetooth via rfkill also disables
> my wireless card on my HP Pavilion dm4. This didn't happen with 2.6.41
> (I upgraded from Fedora 15 to 16).
> 
> My devices are set up as this (see attached output of lspci -vnn for
> details about devices):
> # rfkill list
> 0: phy0: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no
> 2: hp-wifi: Wireless LAN
> 	Soft blocked: no
> 	Hard blocked: no
> 3: hp-bluetooth: Bluetooth
> 	Soft blocked: no
> 	Hard blocked: no
> 11: hci0: Bluetooth
> 	Soft blocked: no
> 	Hard blocked: no
> 
> The problem is, these commands also stop the WiFi:
> rfkill block bluetooth
> and
> rfkill block 3 [for hp-bluetooth]
> 
> But this one only kills the Bluetooth:
> rfkill block 11
> 
> 
> Running
> rfkill block wifi
> does kill the WiFi, but leaves the Bluetooth up.
> 
> 
> (If it matters, running 'rfkill block bluetooth' makes hci0 disappear,
> and after unblocking bluetooth, it reappears with the ID increased by 1.
> This doesn't happen with the WiFi.)
> 
> 
> Please ask if I can provide more information/testing.
> 
> 
> Thanks for your help.
> 
> 
> PS : Please keep me in CC: as I'm not subscribed to the list.

Please provide dmesg, acpidump and dmidecode, run the following command
and attached on mail:
	dmesg > dmesg.log
	acpidump > acpidump.dat
	dmidecode > dmidecode.log


Thanks a lot!
Joey Lee

