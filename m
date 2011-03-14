Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab1CNRlN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Mar 2011 13:41:13 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:56216 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab1CNRlK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Mar 2011 13:41:10 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:subject
         :content-type:content-transfer-encoding;
        b=CAnWGvngv8fH5b8+uvbH5MuTC4LcbsdlHqqL7SC4sTFsFvcXFw7ubhO7Huzubiw62t
         XcBmo3btsnAyzz52QCcxsLPzIF9jTeKmu3mlzYJramKg391vkSOoUC8312X57zPj7ACD
         LkMnNJwoEf8W0bw6OFT2W2tkJzcb/S23+WmzE=
Message-ID: <4D7E532E.8050705@gmail.com>
Date: Mon, 14 Mar 2011 10:41:02 -0700
From: "Justin P. Mattock" <justinmattock@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101220 Thunderbird/3.1.7
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: general protection fault: 0000 [#1] SMP
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ive seen this before, this time though once this fired off the screen
kind of got garbled but the system was usable.
Note: I am having an issue with radeon(trying to figure out another 
issue)so maybe this is part of what I am seeing..:

  [ 7820.017431] general protection fault: 0000 [#1] SMP
[ 7820.017538] last sysfs file: 
/sys/devices/pci0000:00/0000:00:1d.3/usb5/5-1/5-1:1.0/bluetooth/hci0/hci0:46/input14/capabilities/sw
[ 7820.017628] CPU 0
[ 7820.017656] Modules linked in: evdev hidp xfrm4_mode_transport xcbc 
rmd160 sha512_generic rfcomm sco bnep l2cap radeon drm_kms_helper 
ipt_REJECT xt_tcpudp ipt_LOG iptable_nat nf_nat xt_state 
nf_conntrack_ftp nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 
iptable_filter ip_tables x_tables btusb bluetooth psmouse thermal fan 
container button ac battery video ath9k ath9k_common ath9k_hw ath ttm 
drm aes_x86_64 lzo zlib ipcomp xfrm_ipcomp crypto_null des_generic cast5 
blowfish serpent camellia twofish_generic twofish_x86_64 twofish_common 
ctr ah4 esp4 authenc firewire_ohci firewire_core uhci_hcd ehci_hcd 
coretemp acpi_cpufreq processor mperf appletouch applesmc
[ 7820.018011]
[ 7820.018011] Pid: 508, comm: kswapd0 Not tainted 
2.6.38-rc8-00123-g41d5502 #2 Apple Computer, Inc. MacBookPro2,2/Mac-F42187C8
[ 7820.018011] RIP: 0010:[<ffffffff8110eb45>]  [<ffffffff8110eb45>] 
evict+0x10/0x88
[ 7820.018011] RSP: 0000:ffff88003d645cb0  EFLAGS: 00010282
[ 7820.018011] RAX: e08e66c08e66d88e RBX: ffff88000008f050 RCX: 
0000000000000025
[ 7820.018011] RDX: ffff8800223e8188 RSI: ffffffff8116a98f RDI: 
ffff88000008f050
[ 7820.018011] RBP: ffff88003d645cc0 R08: 0000000000000080 R09: 
ffff880039cf6f80
[ 7820.018011] R10: ffff88003d645b80 R11: ffff880039cf70d8 R12: 
ffff88003d645d00
[ 7820.018011] R13: ffff88000008f108 R14: 0000000000000080 R15: 
0000000000000080
[ 7820.018011] FS:  0000000000000000(0000) GS:ffff88003ee00000(0000) 
knlGS:0000000000000000
[ 7820.018011] CS:  0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[ 7820.018011] CR2: 0000000000a9e000 CR3: 0000000008f26000 CR4: 
00000000000006f0
[ 7820.018011] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 
0000000000000000
[ 7820.018011] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 
0000000000000400
[ 7820.018011] Process kswapd0 (pid: 508, threadinfo ffff88003d644000, 
task ffff88003d669560)
[ 7820.018011] Stack:
[ 7820.018011]  ffff880039cf7050 ffff88000008f050 ffff88003d645cf0 
ffffffff8110f17d
[ 7820.018011]  0000000000000000 ffff880005417a78 ffff880005417a88 
0000000000000000
[ 7820.018011]  ffff88003d645d40 ffffffff8110f9bb ffff8800223e8188 
ffff880002ba3a88
[ 7820.018011] Call Trace:
[ 7820.018011]  [<ffffffff8110f17d>] dispose_list+0x47/0xe3
[ 7820.018011]  [<ffffffff8110f9bb>] shrink_icache_memory+0x281/0x2b3
[ 7820.018011]  [<ffffffff810d04dc>] shrink_slab+0xde/0x162
[ 7820.018011]  [<ffffffff810d0b21>] kswapd+0x5c1/0x9af
[ 7820.018011]  [<ffffffff810d0560>] ? kswapd+0x0/0x9af
[ 7820.018011]  [<ffffffff8107bdaf>] kthread+0x7d/0x85
[ 7820.018011]  [<ffffffff8102e064>] kernel_thread_helper+0x4/0x10
[ 7820.018011]  [<ffffffff8107bd32>] ? kthread+0x0/0x85
[ 7820.018011]  [<ffffffff8102e060>] ? kernel_thread_helper+0x0/0x10
[ 7820.018011] Code: 10 81 be 07 00 00 00 e8 2f cc 33 00 48 c7 83 88 00 
00 00 60 00 00 00 5f 5b c9 c3 55 48 89 e5 53 48 89 fb 48 83 ec 08 48 8b 
47 18 <48> 8b 40 30 48 8b 40 28 48 85 c0 74 04 ff d0 eb 20 48 83 bf 10
[ 7820.018011] RIP  [<ffffffff8110eb45>] evict+0x10/0x88
[ 7820.018011]  RSP <ffff88003d645cb0>
[ 7820.028800] ---[ end trace 506063ca7889c564 ]---


full dmesg here:
http://fpaste.org/wzgx/

Justin P. Mattock

