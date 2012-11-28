Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755247Ab2K1Nde (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 08:33:34 -0500
Received: from nm38-vm9.bullet.mail.bf1.yahoo.com ([72.30.239.25]:37930 "EHLO
	nm38-vm9.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755047Ab2K1Ndc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 08:33:32 -0500
X-Greylist: delayed 345 seconds by postgrey-1.27 at vger.kernel.org; Wed, 28 Nov 2012 08:33:31 EST
X-Yahoo-Newman-Property: ymail-5
X-Yahoo-Newman-Id: 102482.24969.bm@omp1050.mail.bf1.yahoo.com
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws;
  s=s1024; d=yahoo.com;
  h=X-YMail-OSG:Received:X-Rocket-MIMEInfo:X-Mailer:Message-ID:Date:From:Subject:To:MIME-Version:Content-Type;
  b=qfA1g9mvnd7BKnd5w/xNo/a0DDbzb3gQT1yEcA07/UZBEUEWSY/1kk8ZdKJzT+YDsW7V6SuJsn8upTv3AFOQ551/8W/1VvxpnF3O1sqvaPDeeJa//4PnBZ3FN7BnqYnvciftlOzmfpos1GCdwHT23DSldz7zwCwiH4RHy+VCGKE=;
X-YMail-OSG: tnVxnfAVM1mjQUkraBDTTMYNqbWhCVkIa6.dVQXB2RiAdhm
 7JbIJ3FRxCfNxJVhKvIDM5ZAygUdPkvpssWI8WbHtN.8YWu2TmJGCE4ZzRuD
 9Lp29HLODpNueThv32uQ4zc7QycQ3mROChbK7kyEpe.PMRRC6OhOpo8MZKn8
 PJ.b5o2jkKIQeNQdk9r_7YOoSq.lPvouCOsZQXarm5Szoz5B9yDtelNu0wN0
 uFnIlQRAZJC.XSwXXZRJh8FHgD5MN9SzAACtgLmVQpRE4sRdLHfS_n0UoaHG
 YmywE18zOvJ9qLxxGlnna6cflMOdJdeUMLybmTIh9WCJpX.k65LAZ5rowgGk
 nONRGSoo55QzkRWnDRiwFSIiN0yf3.Yxew1S3vt0uOfi_S5N625ZKdmBvxQn
 qLHNPWGCu0dGcx0G8EE8lxRxxMmqEuRkEluuO8jjzSDGRrkU.RJtgAnYfrtS
 JK3DSA6wYehqm6UsAoVUhU9tjrW3yPyNNpOxXthGfBtQgk2Nf6C05
X-Rocket-MIMEInfo: 001.001,SW0gdXNpbmcga2VybmVsIChMaW51eCBpbml0Ym94IDMuNi43LTEtQVJDSCAjMSBTTVAgUFJFRU1QVCBTdW4gTm92IDE4IDEwOjExOjIyIENFVCAyMDEyIHg4Nl82NCBHTlUvTGludXgpIGFuZCBpIHNlZSBzb21lIHByb2JsZW1zIGF0IGJvb3RpbmcuLi4gU28gZG1lc2cgb3V0cHV0IHdpdGggQlVHIGxpbmVzOgoKJCBkbWVzZyB8Z3JlcCBCdWcKWyAgICAxLjM2MzE1NF0gW0Zpcm13YXJlIEJ1Z106IEFDUEk6IEJJT1MgX09TSShMaW51eCkgcXVlcnkgaWdub3JlZApbICAgIDEuMzczNzg0XSBbRmlybXdhcmUgQnUBMAEBAQE-
X-Mailer: YahooMailClassic/15.0.8 YahooMailWebService/0.8.127.475
Message-ID: <1354109265.69986.YahooMailClassic@web163004.mail.bf1.yahoo.com>
Date: Wed, 28 Nov 2012 05:27:45 -0800 (PST)
From: Denis Lotarev <dlotarev@yahoo.com>
Subject: [FIRMWARE BUG] Lenovo x120e
To: linux-kernel@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Im using kernel (Linux initbox 3.6.7-1-ARCH #1 SMP PREEMPT Sun Nov 18 10:11:22 CET 2012 x86_64 GNU/Linux) and i see some problems at booting... So dmesg output with BUG lines:

$ dmesg |grep Bug
[    1.363154] [Firmware Bug]: ACPI: BIOS _OSI(Linux) query ignored
[    1.373784] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    1.380827] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness
[    1.433354] pnp 00:09: [Firmware Bug]: [mem 0x00000000-0xffffffffffffffff disabled] covers only part of AMD MMCONFIG area [mem 0xf8000000-0xf9ffffff]; adding more reservations
[    3.349658] [Firmware Bug]: ACPI: No _BQC method, cannot determine initial brightness

$ lspci 
00:00.0 Host bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Complex
00:01.0 VGA compatible controller: Advanced Micro Devices [AMD] nee ATI Wrestler [Radeon HD 6310]
00:01.1 Audio device: Advanced Micro Devices [AMD] nee ATI Wrestler HDMI Audio [Radeon HD 6250/6310]
00:06.0 PCI bridge: Advanced Micro Devices [AMD] Family 14h Processor Root Port
00:11.0 SATA controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 SATA Controller [AHCI mode]
00:12.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:12.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:13.0 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB OHCI0 Controller
00:13.2 USB controller: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 USB EHCI Controller
00:14.0 SMBus: Advanced Micro Devices [AMD] nee ATI SBx00 SMBus Controller (rev 42)
00:14.2 Audio device: Advanced Micro Devices [AMD] nee ATI SBx00 Azalia (Intel HDA) (rev 40)
00:14.3 ISA bridge: Advanced Micro Devices [AMD] nee ATI SB7x0/SB8x0/SB9x0 LPC host controller (rev 40)
00:14.4 PCI bridge: Advanced Micro Devices [AMD] nee ATI SBx00 PCI to PCI Bridge (rev 40)
00:15.0 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 0)
00:15.1 PCI bridge: Advanced Micro Devices [AMD] nee ATI SB700/SB800/SB900 PCI to PCI bridge (PCIE port 1)
00:18.0 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 0 (rev 43)
00:18.1 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 1
00:18.2 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 2
00:18.3 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 3
00:18.4 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 4
00:18.5 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 6
00:18.6 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 5
00:18.7 Host bridge: Advanced Micro Devices [AMD] Family 12h/14h Processor Function 7
01:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd. RTL8111/8168B PCI Express Gigabit Ethernet controller (rev 03)
04:00.0 Network controller: Atheros Communications Inc. AR9285 Wireless Network Adapter (PCI-Express) (rev 01)

$ lsusb
Bus 001 Device 003: ID 413c:8147 Dell Computer Corp. F3507g Mobile Broadband Module
Bus 002 Device 003: ID 064e:e201 Suyin Corp. Lenovo Integrated Webcam
Bus 003 Device 002: ID 0a5c:217f Broadcom Corp. Bluetooth Controller
Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
Bus 003 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub
Bus 004 Device 001: ID 1d6b:0001 Linux Foundation 1.1 root hub


Your sincerely, Denis Lotarev
