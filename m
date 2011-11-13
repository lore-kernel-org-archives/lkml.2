Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754710Ab1KMAxD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 Nov 2011 19:53:03 -0500
Received: from a2s42.a2hosting.com ([216.119.133.2]:60551 "EHLO
	a2s42.a2hosting.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752473Ab1KMAxB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 Nov 2011 19:53:01 -0500
X-Greylist: delayed 2909 seconds by postgrey-1.27 at vger.kernel.org; Sat, 12 Nov 2011 19:53:01 EST
Message-ID: <4EBF099A.3090701@kerneldriver.org>
Date: Sat, 12 Nov 2011 19:04:42 -0500
From: David Cullen <david.cullen@kerneldriver.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:7.0.1) Gecko/20110929 Thunderbird/7.0.1
MIME-Version: 1.0
To: linux-kernel@vger.kernel.org
Subject: PROBLEM: Toshiba Satellite L775D-S7340 reboots during shutdown
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - a2s42.a2hosting.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - kerneldriver.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Toshiba Satellite L775D-S7340 reboots during shutdown.

When I shutdown my machine when running the default kernel for Linux 
Mint 11 and the default kernel for Ubuntu 11.10, the machine reboots 
instead of halting.

I am currently running

> Linux drawork01 3.0.0-12-generic #20-Ubuntu SMP Fri Oct 7 14:56:25 UTC 2011 x86_64 x86_64 x86_64 GNU/Linux
>
> Gnu C                  4.6.1
> Gnu make               3.81
> binutils               2.21.53.20110810
> util-linux             2.19.1
> mount                  support
> module-init-tools      3.16
> e2fsprogs              1.41.14
> pcmciautils            015
> Linux C Library        2.13
> Dynamic linker (ldd)   2.13
> Procps                 3.2.8
> Net-tools              1.60
> Kbd                    1.15.2
> Sh-utils               8.5
> wireless-tools         30
> Modules Loaded         rfcomm bnep bluetooth parport_pc ppdev
> nfsd binfmt_misc nfs lockd fscache auth_rpcgss nfs_acl sunrpc
> vesafb uvcvideo videodev v4l2_compat_ioctl32 arc4
> snd_hda_codec_realtek snd_seq_midi snd_hda_codec_hdmi psmouse
> serio_raw rtl8192ce rtl8192c_common snd_hda_intel rtlwifi
> snd_hda_codec k10temp snd_hwdep mac80211 snd_rawmidi snd_pcm
> cfg80211 snd_seq_midi_event snd_seq sparse_keymap video snd_timer
> snd_seq_device wmi fglrx snd soundcore snd_page_alloc i2c_piix4
> lp parport usbhid hid ums_realtek usb_storage uas r8169
> pata_atiixp ahci libahci

I have the problem even without the fglrx driver.  I can uninstall 
it and re-run

     sh scripts/ver_linux

if that is required for this defect to be looked at.

-- 
Thank you,
David Cullen
