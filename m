Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753418Ab0K3PA0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 10:00:26 -0500
Received: from smtp-out5.blueyonder.co.uk ([195.188.213.8]:34726 "EHLO
	smtp-out5.blueyonder.co.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751498Ab0K3PAY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 10:00:24 -0500
Message-ID: <4CF5116B.8040204@blueyonder.co.uk>
Date: Tue, 30 Nov 2010 14:59:55 +0000
From: Sid Boyce <sboyce@blueyonder.co.uk>
Reply-To: sboyce@blueyonder.co.uk
Organization: blueyonder.co.uk
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-GB; rv:1.9.2.12) Gecko/20101027 Thunderbird/3.1.6 ThunderBrowse/3.3.2
MIME-Version: 1.0
To: LKML Mailing List <linux-kernel@vger.kernel.org>,
        opensuse factory list <opensuse-factory@opensuse.org>
Subject: 2.6.37-rc3-git installed modules zero bytes long
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

openSUSE 11.3 on one box and openSUSE 11.4 Milestone 4 on the other.
I have a message that says the built modules not found. When I check 
e.g /lib/modules/2.7.37-rc3-git7-smp, most modules are zero bytes long.
I have to "make modules_install" and use modprobe on each.
To get the network up on the 11.3 box "modprobe r6189" then "rcnetwork 
restart", "modprobe rtl8187", "/etc/init.d/network-remotefs start", 
etc., etc.
Then ifconfig is OK for those devices.
eth_s1_0  Link encap:Ethernet  HWaddr 00:1C:F0:BB:14:E1
           inet addr:192.168.10.10  Bcast:192.168.10.255  Mask:255.255.255.0
           inet6 addr: fe80::21c:f0ff:febb:14e1/64 Scope:Link
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:1927 errors:0 dropped:0 overruns:0 frame:0
           TX packets:1923 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:287532 (280.7 Kb)  TX bytes:283044 (276.4 Kb)
           Interrupt:17 Base address:0xe000
wlan0     Link encap:Ethernet  HWaddr 00:15:AF:23:04:37
           inet addr:192.168.1.4  Bcast:192.168.1.255  Mask:255.255.255.0
           inet6 addr: fe80::215:afff:fe23:437/64 Scope:Link
           UP BROADCAST RUNNING MULTICAST  MTU:1500  Metric:1
           RX packets:25 errors:0 dropped:0 overruns:0 frame:0
           TX packets:62 errors:0 dropped:0 overruns:0 carrier:0
           collisions:0 txqueuelen:1000
           RX bytes:4324 (4.2 Kb)  TX bytes:18470 (18.0 Kb)

On 11.3 module-init-tools-3.12-1.3.x86_64
On 11.4 Milestone 4 module-init-tools-3.12-5.3.x86_64

tindog:/usr/src/linux-2.6.37-rc3-git7 # grep MODULE .config
CONFIG_MODULES=y
# CONFIG_MODULE_FORCE_LOAD is not set
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_MODULE_SRCVERSION_ALL=y


Another guy has emailed me saying he's seen the same.
11.3
====
gcc version 4.5.0 20100604 [gcc-4_5-branch revision 160292] (SUSE Linux)
11.4 Milestone 4
================
gcc version 4.5.1 20101116 [gcc-4_5-branch revision 166793] (SUSE Linux)
Regards
Sid.
-- 
Sid Boyce ... Hamradio License G3VBV, Licensed Private Pilot
Emeritus IBM/Amdahl Mainframes and Sun/Fujitsu Servers Tech Support
Senior Staff Specialist, Cricket Coach
Microsoft Windows Free Zone - Linux used for all Computing Tasks

