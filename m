Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755178Ab1BCIU2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 03:20:28 -0500
Received: from smtp.witbe.net ([81.88.96.48]:51036 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754358Ab1BCIU0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 03:20:26 -0500
Date: Thu, 3 Feb 2011 09:19:48 +0100
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        "Dave Airlie" <airlied@redhat.com>,
        "Keith Packard" <keithp@keithp.com>, rol@witbe.net
Subject: Re: [Bug #22542] [2.6.37-rc1] drm:i195 errors
Message-ID: <20110203091948.44aa7c8b@tux.DEF.witbe.net>
In-Reply-To: <-tcJxClTQPH.A.QUG.J_eSNB@chimera>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
	<-tcJxClTQPH.A.QUG.J_eSNB@chimera>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.7 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Thu,  3 Feb 2011 01:03:49 +0100 (CET)
"Rafael J. Wysocki" <rjw@sisk.pl> wrote:

> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.36 and 2.6.37.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.36 and 2.6.37.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=22542
> Subject		: [2.6.37-rc1] drm:i195 errors
> Submitter	: Paul Rolland <rol@witbe.net>
> Date		: 2010-11-02 14:58 (93 days old)
> Message-ID	: <20101102155813.09cb2c6e@tux.DEF.witbe.net>
> References	: http://marc.info/?l=linux-kernel&m=128870991628970&w=2

[root@tux ~]# uname -a
Linux tux.DEF.witbe.net 2.6.38-rc3 #1 SMP Tue Feb 1 08:49:29 CET 2011 x86_64 x86_64 x86_64 GNU/Linux

[root@tux ~]# grep i915 /var/log/messages
Feb  1 19:27:43 tux kernel: i915 0000:00:02.0: PCI INT A -> GSI 16 (level, low) -> IRQ 16
Feb  1 19:27:43 tux kernel: [drm] Initialized i915 1.6.0 20080730 for 0000:00:02.0 on minor 0
Feb  1 19:45:03 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
...
Feb  2 18:18:04 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
Feb  2 18:18:04 tux kernel: [drm:i915_gem_mmap_gtt_ioctl] *ERROR* Attempting to mmap a purgeable buffer
Feb  2 19:03:34 tux kernel: [drm:i915_gem_object_bind_to_gtt] *ERROR* Attempting to bind a purgeable object
Feb  2 19:03:49 tux kernel: RIP: 0010:[<ffffffff81326378>]  [<ffffffff81326378>] i915_gem_object_unpin+0xa8/0xb0
Feb  2 19:03:49 tux kernel: [<ffffffff8131a755>] i915_driver_lastclose+0x35/0x70
Feb  2 19:03:49 tux kernel: RIP  [<ffffffff81326378>] i915_gem_object_unpin+0xa8/0xb0


Hmmm... Even got a crash, probably that's why my KDE session was killed
yesterday :(

Feb  2 19:03:34 tux kernel: [drm:i915_gem_object_bind_to_gtt] *ERROR* Attempting
 to bind a purgeable object
Feb  2 19:03:36 tux kdm[1426]: X server for display :0 terminated unexpectedly
Feb  2 19:03:49 tux kdm: :0[2103]: Abnormal termination of greeter for display :
0, code 1, signal 0
Feb  2 19:03:49 tux kdm: :0[2103]: Fatal X server IO error: Interrupted system call
Feb  2 19:03:49 tux kernel: Kernel BUG at ffffffff81326378 [verbose debug info u
navailable]
Feb  2 19:03:49 tux kernel: invalid opcode: 0000 [#1] SMP 
Feb  2 19:03:49 tux kernel: last sysfs file: /sys/devices/pci0000:00/0000:00:02.
1/resource
Feb  2 19:03:49 tux kernel: CPU 1 
Feb  2 19:03:49 tux kernel: Modules linked in: vboxnetadp vboxnetflt vboxdrv snd
_seq_dummy bluetooth tcp_lp fuse vfat fat coretemp hwmon cpufreq_ondemand acpi_c
pufreq freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ipv6 dm_cry
pt ipheth uvcvideo snd_hda_codec_idt ecb snd_hda_intel snd_hda_codec iTCO_wdt iw
l3945 snd_hwdep snd_seq snd_seq_device snd_pcm iwlcore mac80211 cfg80211 iTCO_ve
ndor_support r8169 dell_laptop snd_timer mii snd rfkill i2c_i801 soundcore micro
code snd_page_alloc dcdbas mmc_block sdhci_pci sdhci mmc_core firewire_ohci fire
wire_core [last unloaded: ip6_tables]
Feb  2 19:03:49 tux kernel:
Feb  2 19:03:49 tux kernel: Pid: 2116, comm: X Not tainted 2.6.38-rc3 #1 0T816J/
Vostro 1520
Feb  2 19:03:49 tux kernel: RIP: 0010:[<ffffffff81326378>]  [<ffffffff81326378>]
 i915_gem_object_unpin+0xa8/0xb0
Feb  2 19:03:49 tux kernel: RSP: 0018:ffff88011f7ddcc8  EFLAGS: 00010246
Feb  2 19:03:49 tux kernel: RAX: ffff88013a523800 RBX: ffff88013a523000 RCX: fff
f88013a523c28
Feb  2 19:03:49 tux kernel: RDX: 00000000000600fa RSI: ffff88013a0c8000 RDI: fff
f88013a15ae00
Feb  2 19:03:49 tux kernel: RBP: ffff88011f7ddcc8 R08: ffff88013a51b6c8 R09: 000
0000000000000
Feb  2 19:03:49 tux kernel: R10: ffff88013a523c40 R11: 0000000000003246 R12: fff
f88013a523820
Feb  2 19:03:49 tux kernel: R13: ffff88013a523c58 R14: ffff8800ab5d98c0 R15: fff
f88013a523c28
Feb  2 19:03:49 tux kernel: FS:  00007f374f38c840(0000) GS:ffff8800bd500000(0000
) knlGS:0000000000000000
Feb  2 19:03:49 tux kernel: CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
Feb  2 19:03:49 tux kernel: CR2: 00000000007c9ec4 CR3: 0000000114d07000 CR4: 000
00000000406e0
Feb  2 19:03:49 tux kernel: DR0: 0000000000000000 DR1: 0000000000000000 DR2: 000
0000000000000
Feb  2 19:03:49 tux kernel: DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 000
0000000000400
Feb  2 19:03:49 tux kdm[1426]: X server died during startup
Feb  2 19:03:49 tux kdm[1426]: X server for display :0 cannot be started, sessin disabled
Feb  2 19:03:49 tux kernel: Process X (pid: 2116, threadinfo ffff88011f7dc000, task ffff880108948500)
Feb  2 19:03:49 tux kernel: Stack:
Feb  2 19:03:49 tux kernel: ffff88011f7ddce8 ffffffff81333325 ffff88013a523000 ffffffff81a3cae0
Feb  2 19:03:49 tux kernel: ffff88011f7ddd18 ffffffff812ff3bd ffff8800ab5d98c0 ffff88013a157988
Feb  2 19:03:49 tux kernel: ffff8800ab5d98c0 0000000000000000 ffff88011f7dddd8 ffffffff813004af
Feb  2 19:03:49 tux kernel: Call Trace:
Feb  2 19:03:49 tux kernel: [<ffffffff81333325>] intel_crtc_disable+0x45/0x60
Feb  2 19:03:49 tux kernel: [<ffffffff812ff3bd>] drm_helper_disable_unused_functions+0x13d/0x180
Feb  2 19:03:49 tux kernel: [<ffffffff813004af>] drm_crtc_helper_set_config+0x82f/0xa00
Feb  2 19:03:49 tux kernel: [<ffffffff81304e73>] ? drm_ioctl+0x3d3/0x4e0
Feb  2 19:03:49 tux kernel: [<ffffffff812fecf9>] drm_fb_helper_force_kernel_mode+0x79/0xb0
Feb  2 19:03:49 tux kernel: [<ffffffff812fed39>] drm_fb_helper_restore+0x9/0x30
Feb  2 19:03:49 tux kernel: [<ffffffff8131a755>] i915_driver_lastclose+0x35/0x70
Feb  2 19:03:49 tux kernel: [<ffffffff81305204>] drm_lastclose+0x44/0x300
Feb  2 19:03:49 tux kernel: [<ffffffff81305c13>] drm_release+0x503/0x6b0
Feb  2 19:03:49 tux kernel: [<ffffffff810f7f52>] fput+0xe2/0x260
Feb  2 19:03:49 tux kernel: [<ffffffff810f4a78>] filp_close+0x58/0x90
Feb  2 19:03:49 tux kernel: [<ffffffff810f4b40>] sys_close+0x90/0xe0
Feb  2 19:03:49 tux kernel: [<ffffffff8100243b>] system_call_fastpath+0x16/0x1b
Feb  2 19:03:49 tux kernel: Code: 89 96 d0 15 00 00 48 81 c6 c8 15 00 00 48 89 87 b8 00 00 00 48 89 b7 b0 00 00 00 48 89 10 80 a7 e2 00 00 00 f7 c9 c3 0f 0b eb fe <0f> 0b eb fe 0f 1f 40 00 55 48 89 f8 48 89 e5 48 8b bf e8 00 00 
Feb  2 19:03:49 tux kernel: RIP  [<ffffffff81326378>] i915_gem_object_unpin+0xa8/0xb0
Feb  2 19:03:49 tux kernel: RSP <ffff88011f7ddcc8>
Feb  2 19:03:49 tux kernel: ---[ end trace 83ffc517ec5d0200 ]---

Paul

-- 
Paul Rolland                                E-Mail : rol(at)witbe.net
CTO - Witbe.net SA                          Tel. +33 (0)1 47 67 77 77
Les Collines de l'Arche                     Fax. +33 (0)1 47 67 77 99
F-92057 Paris La Defense                    RIPE : PR12-RIPE

LinkedIn : http://www.linkedin.com/in/paulrolland
Skype    : rollandpaul

"I worry about my child and the Internet all the time, even though she's
too young to have logged on yet. Here's what I worry about. I worry that 10
or 15 years from now, she will come to me and say 'Daddy, where were you
when they took freedom of the press away from the Internet?'"
--Mike Godwin, Electronic Frontier Foundation 


