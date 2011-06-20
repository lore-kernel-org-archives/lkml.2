Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753560Ab1FTHra (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jun 2011 03:47:30 -0400
Received: from smtp.witbe.net ([81.88.96.48]:46237 "EHLO smtp.witbe.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753406Ab1FTHr2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jun 2011 03:47:28 -0400
Date: Mon, 20 Jun 2011 09:47:25 +0200
From: Paul Rolland (=?UTF-8?B?44Od44O844Or44O744Ot44Op44Oz?=) 
	<rol@witbe.net>
To: linux-kernel@vger.kernel.org
Cc: rol@witbe.net
Subject: WARNING: at net/ipv4/route.c:1677 ip_rt_bug+0x5a/0x70()
Message-ID: <20110620094725.3508a4e4@tux.DEF.witbe.net>
Organization: Witbe.net
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
X-Ncc-RegId: fr.witbe
X-Face: +^rP^g;Vjb!M*"%3$mF6xWU{DwwAx)W=b_<WXQMv}Rk8,fQ)?Wnk0NK/+m,;eWci?+;=I}d^:]I+)D+|r'vxjYjp.?o-8Va|&sD*-GVKn>}?Y)|*X<5cv@M`1P{\:)p9_:$=)(NY2`%AcypV*]z>YIyy5yY"9PUoV5@)*(W:S5e-48Ct7Wu6CkkO[=KB"ox,_2B/FwY&hr/E1H&<9IbOCx6NrBa"}FLA)UIvHg`9%NC\LfYB3ia]
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWsjH1VRjFydFciEg3a1tJxUEM6OCB1zdsDAAACcElEQVQ4jV2Tu3LcMAxFEY7SG/KQNYlY2685Zi1rmF5kQteBNcL/f0JAacfZDUscARePK9itY3Q4Qu5vplJKIFsrvI0t7Ii/8/nmQsERtgJpHAtiGW4ggylOAwhXTxPi0xfIcxDrZIc3qhMGD/kfKdwBExZrAf6l5PeC/Al7cAGfAGD+AgvL5yckcsxegVmG+QZRPgnYXnFUMAC8DLd6QZhAxj6dRo6vT/JNkmZQmPyDtoroMkD2VlaVgHsw2QrCAf1jPM+ou2Ju1j/G8+xINfZT+zGDPDjr7H/xnKewgi6SO4D7zloYoRDafSoogmirP0t9YIOJnN2ibDEKK6zDoSEjTIFXDcYYkwizoO/AjkATm3g+JVsSXPOCZIHwj7uBo2Bi97RMOoflJ4n3b3dvS2kVXDQupjvAk7zvaMEJlu0OJDFy4SsCusRbL95jRynY0LIA/rpyxCMkJ1ie+bWoEy+MG7pzDE3k8Z2C1a5eUdxmi0adGi2mdVjyUr2uvamrW9EeuLTCY84/AUjBj40LtqYbbM23vqolA2mpj5g03gparH45DqBgmsBK2hU0x662+QQLVYJLitxTnHB7yf0es4rraS/xqKW/hF1zPg9lOijpmtIBVrWKOQ6oTSkQjh3YtnarHQc0RrtS1XjtbQnScPrLeNKM6iS+6Qz6e9mVoPvaHHPU6eP5aKu1Ifd2QQvp6EA1bLaP3VREwewXY73xgLppBR2tg4LFg9lXzegHQlusWuxwogLCaswJ+qunQ2cyfuziX6B1p0E26nQazR3Qn2jQarRXVVZT9zP3uB5FV6pNjQG+u03ugbalEsEXqo7/AjAH60VpvOMvAAAAAElFTkSuQmCC
Mime-Version: 1.0
Content-Type: multipart/signed; micalg=PGP-SHA1;
 boundary="Sig_/kyJScA16Jib6mLHGh3O8TnU"; protocol="application/pgp-signature"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--Sig_/kyJScA16Jib6mLHGh3O8TnU
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: quoted-printable

Hello,

I'm getting a series of these warning when I start a 64bit Win7 inside
VirtualBox in a 64bit 3.0.0-rc3 linux.

This happens when I open the session, not during the boot process. Here is
a copy of the very first warning.

Jun 20 09:44:35 tux kernel: ------------[ cut here ]------------
Jun 20 09:44:35 tux kernel: WARNING: at net/ipv4/route.c:1677 ip_rt_bug+0x5=
a/0x70()
Jun 20 09:44:35 tux kernel: Hardware name: Vostro 1520
Jun 20 09:44:35 tux kernel: Modules linked in: tcp_lp fuse ipheth vfat fat =
vboxnetadp vboxnetflt vboxdrv coretemp hwmon cpufreq_ondemand acpi_cpufreq =
freq_table mperf ip6t_REJECT nf_conntrack_ipv6 nf_defrag_ipv6 ip6table_filt=
er ip6_tables ipv6 dm_crypt snd_hda_codec_idt snd_hda_intel snd_hda_codec s=
nd_hwdep snd_seq uvcvideo snd_seq_device snd_pcm snd_timer snd soundcore iw=
l3945 iwl_legacy mac80211 dell_laptop r8169 cfg80211 dcdbas mii iTCO_wdt iT=
CO_vendor_support snd_page_alloc rfkill i2c_i801 microcode mmc_block sdhci_=
pci sdhci mmc_core firewire_ohci firewire_core [last unloaded: scsi_wait_sc=
an]
Jun 20 09:44:35 tux kernel: Pid: 4848, comm: VirtualBox Not tainted 3.0.0-r=
c3 #2
Jun 20 09:44:35 tux kernel: Call Trace:
Jun 20 09:44:35 tux kernel: [<ffffffff8104c5aa>] warn_slowpath_common+0x7a/=
0xb0
Jun 20 09:44:35 tux kernel: [<ffffffff8104c5f5>] warn_slowpath_null+0x15/0x=
20
Jun 20 09:44:35 tux kernel: [<ffffffff814bc9aa>] ip_rt_bug+0x5a/0x70
Jun 20 09:44:35 tux kernel: [<ffffffff814c5a54>] ip_local_out+0x24/0x30
Jun 20 09:44:35 tux kernel: [<ffffffff814c5a69>] ip_send_skb+0x9/0x50
Jun 20 09:44:35 tux kernel: [<ffffffff814e8905>] udp_send_skb+0x115/0x3a0
Jun 20 09:44:35 tux kernel: [<ffffffff814c4f90>] ? ip_append_page+0x570/0x5=
70
Jun 20 09:44:35 tux kernel: [<ffffffff814ea218>] udp_sendmsg+0x338/0x940
Jun 20 09:44:35 tux kernel: [<ffffffff8110bd90>] ? __pollwait+0xf0/0xf0
Jun 20 09:44:35 tux kernel: [<ffffffff814f24e3>] inet_sendmsg+0x43/0xb0
Jun 20 09:44:35 tux kernel: [<ffffffff81051c02>] ? current_fs_time+0x22/0x30
Jun 20 09:44:35 tux kernel: [<ffffffff8110bd90>] ? __pollwait+0xf0/0xf0
Jun 20 09:44:35 tux kernel: [<ffffffff81475646>] sock_sendmsg+0x106/0x120
Jun 20 09:44:35 tux kernel: [<ffffffff814c76f0>] ? do_ip_setsockopt+0x80/0x=
d60
Jun 20 09:44:35 tux kernel: [<ffffffff815422bf>] ? _raw_spin_unlock_bh+0xf/=
0x20
Jun 20 09:44:35 tux kernel: [<ffffffff814eb94b>] ? udp_lib_get_port+0x20b/0=
x340
Jun 20 09:44:35 tux kernel: [<ffffffff8147516a>] ? move_addr_to_kernel+0x6a=
/0x70
Jun 20 09:44:35 tux kernel: [<ffffffff81475dc4>] sys_sendto+0x134/0x180
Jun 20 09:44:35 tux kernel: [<ffffffff814c84c5>] ? ip_setsockopt+0x45/0x90
Jun 20 09:44:35 tux kernel: [<ffffffff810f8058>] ? fd_install+0x38/0x70
Jun 20 09:44:35 tux kernel: [<ffffffff8109d3bc>] ? audit_syscall_entry+0x1b=
c/0x1f0
Jun 20 09:44:35 tux kernel: [<ffffffff81542bbb>] system_call_fastpath+0x16/=
0x1b
Jun 20 09:44:35 tux kernel: ---[ end trace daa5db172540fc0c ]---

Best,
Paul

--Sig_/kyJScA16Jib6mLHGh3O8TnU
Content-Type: application/pgp-signature; name=signature.asc
Content-Disposition: attachment; filename=signature.asc

-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.14 (GNU/Linux)

iEYEARECAAYFAk3++w0ACgkQZP464AVDf+Aj3QCeIQpELADKtjW/ZFMJYz94Dv+X
crwAoKFPU1X/ue4k3BI3zl3n6fNCk0or
=75uw
-----END PGP SIGNATURE-----

--Sig_/kyJScA16Jib6mLHGh3O8TnU--
