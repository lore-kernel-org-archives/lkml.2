Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760099Ab1CDTW0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 14:22:26 -0500
Received: from mga11.intel.com ([192.55.52.93]:42889 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751320Ab1CDTWZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 14:22:25 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.62,265,1297065600"; 
   d="scan'208";a="893918598"
Subject: Re: FW: 2.6.38-rc7, iwlagn crash
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>, linville@tuxdriver.com
Cc: linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org,
        ilw@linux.intel.com
In-Reply-To: <E9954878DD1FB34FAE5187FB88C58A35013ADC5A59@orsmsx506.amr.corp.intel.com>
References: <E9954878DD1FB34FAE5187FB88C58A35013ADC5A59@orsmsx506.amr.corp.intel.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 04 Mar 2011 11:06:48 -0800
Message-ID: <1299265608.5082.157.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

need help, our tester can not re-pro the problem.
Here are the info from our TE:

=====
Not possible to duplicate this issue.

Here are the three significant messages from the reporter (none
reproduced):

>> [111474.461481] Pid: 1317, comm: wpa_supplicant Tainted: G        W
>> [111488.850445] iwlagn 0000:03:00.0: Unable to find TIM Element in
beacon
>> [111487.424621] wlan0: No active IBSS STAs - trying to scan for other
IBSS networks with same SSID (merge)

If wpa had a problem (first message), the station may be lost (last
message).
>From our testing, we did not find any wpa errors (turned on)

Other issue is that the phone may have issue (second message)
If the reporter can consistently reproduce this issue, it may mandate
more time for testing.

  =====================================================
  Test Case...........: ad-hoc test
  Test Date...........: Fri Mar  4 10:41:44 PST 2011
  WiFi Card...........: PP_2x2
  WiFi Interface......: wlan3
  Kernel Version......: 2.6.38-rc7-vgo.ww10.5.64bit-wl-65093-gaa9f844
  MicroCode Version...: 9.221.4.1 build 25532
  Platform............: SandyBridge
  Hostname............: WSS01009
  Operating System....: Ubuntu 10.10
  =====================================================

eed help, On Fri, 2011-03-04 at 11:12 -0800, Guy, Wey-Yi W wrote:
> 
> -----Original Message-----
> From: John W. Linville [mailto:linville@tuxdriver.com]
> Sent: Friday, March 04, 2011 5:47 AM
> To: Mathias Burén
> Cc: linux-kernel@vger.kernel.org; ilw@linux.intel.com; Guy, Wey-Yi W; linux-wireless@vger.kernel.org
> Subject: Re: 2.6.38-rc7, iwlagn crash
> 
> Cc'ing Wey-yi and linux-wireless...anyone else having problems with
> iwlagn and IBSS?
> 
> On Fri, Mar 04, 2011 at 03:27:22AM +0000, Mathias Burén wrote:
> > Hi,
> >
> > (please cc as not subscribed)
> >
> > I'm running Ubuntu 10.10 and 2.6.38-020638rc7-generic #201103020909
> > SMP Wed Mar 2 09:11:42 UTC 2011 x86_64 GNU/Linux from
> > http://kernel.ubuntu.com/~kernel-ppa/mainline/v2.6.38-rc7-natty/ . The
> > machine is a Lenovo T510 with this chip:
> >
> > 03:00.0 Network controller: Intel Corporation Centrino Advanced-N 6200 (rev 35)
> >
> >  I was trying to setup up an adhoc wifi connection between my phone
> > and the laptop when I saw this in dmesg:
> >
> >
> > [111474.461347] ------------[ cut here ]------------
> > [111474.461377] WARNING: at
> > /home/kernel-ppa/COD/linux/drivers/net/wireless/iwlwifi/iwl-core.c:1898
> > iwl_mac_change_interface+0x12e/0x130 [iwlcore]()
> > [111474.461382] Hardware name: 4384BB3
> > [111474.461384] Modules linked in: nf_nat_h323 nf_conntrack_h323
> > nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gre
> > nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc
> > nf_nat_ftp cdc_acm usbhid hid xt_limit xt_tcpudp ipt_LOG
> > ipt_MASQUERADE xt_DSCP ipt_REJECT nf_conntrack_irc nf_conntrack_ftp
> > xt_state nls_iso8859_1 nls_cp437 vfat fat binfmt_misc vboxnetadp
> > vboxnetflt vboxdrv microcode parport_pc ppdev iptable_nat nf_nat
> > nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle
> > iptable_filter ip_tables x_tables uvcvideo snd_hda_codec_hdmi
> > snd_hda_codec_conexant arc4 videodev v4l2_compat_ioctl32 snd_hda_intel
> > snd_hda_codec snd_hwdep joydev snd_pcm hdaps thinkpad_ec iwlagn
> > snd_seq_midi iwlcore psmouse snd_rawmidi snd_seq_midi_event mac80211
> > snd_seq serio_raw tpm_tis tpm lp parport thinkpad_acpi tpm_bios nvram
> > snd_timer snd_seq_device cfg80211 snd intel_ips soundcore
> > snd_page_alloc sha256_generic aesni_intel cryptd aes_x86_64
> > aes_generic dm_crypt usb_storage uas i915 ahci drm_kms_helper
> > firewire_ohci e1000e libahci sdhci_pci firewire_core drm sdhci
> > crc_itu_t i2c_algo_bit video
> > [111474.461481] Pid: 1317, comm: wpa_supplicant Tainted: G        W
> > 2.6.38-020638rc7-generic #201103020909
> > [111474.461483] Call Trace:
> > [111474.461492]  [<ffffffffa02e6c7e>] ?
> > iwl_mac_change_interface+0x12e/0x130 [iwlcore]
> > [111474.461497]  [<ffffffffa02e6c7e>] ?
> > iwl_mac_change_interface+0x12e/0x130 [iwlcore]
> > [111474.461507]  [<ffffffff81065430>] ? warn_slowpath_common+0x90/0xc0
> > [111474.461510]  [<ffffffff8106547a>] ? warn_slowpath_null+0x1a/0x20
> > [111474.461514]  [<ffffffffa02e6c7e>] ?
> > iwl_mac_change_interface+0x12e/0x130 [iwlcore]
> > [111474.461527]  [<ffffffffa02869ec>] ?
> > ieee80211_runtime_change_iftype+0xdc/0x180 [mac80211]
> > [111474.461535]  [<ffffffffa0286b85>] ?
> > ieee80211_if_change_type+0xf5/0x120 [mac80211]
> > [111474.461543]  [<ffffffffa028995b>] ?
> > ieee80211_change_iface+0x3b/0x130 [mac80211]
> > [111474.461551]  [<ffffffffa01bf898>] ?
> > cfg80211_change_iface+0xe8/0x1c0 [cfg80211]
> > [111474.461558]  [<ffffffffa01d78f6>] ?
> > cfg80211_wext_siwmode+0xa6/0xf0 [cfg80211]
> > [111474.461564]  [<ffffffff8158a4cb>] ? ioctl_standard_call+0x6b/0xf0
> > [111474.461566]  [<ffffffff8158a460>] ? ioctl_standard_call+0x0/0xf0
> > [111474.461569]  [<ffffffff81589882>] ? wireless_process_ioctl+0x102/0x130
> > [111474.461571]  [<ffffffff8158afe0>] ? ioctl_private_call+0x0/0xa0
> > [111474.461573]  [<ffffffff8158afe0>] ? ioctl_private_call+0x0/0xa0
> > [111474.461575]  [<ffffffff8158a460>] ? ioctl_standard_call+0x0/0xf0
> > [111474.461578]  [<ffffffff8158991c>] ? wext_ioctl_dispatch+0x6c/0x90
> > [111474.461580]  [<ffffffff81589b66>] ? wext_handle_ioctl+0x46/0x90
> > [111474.461585]  [<ffffffff814ad76a>] ? sockfd_lookup_light+0x4a/0x80
> > [111474.461589]  [<ffffffff814c687b>] ? dev_ioctl+0x28b/0x2a0
> > [111474.461591]  [<ffffffff814ad25f>] ? sock_ioctl+0xbf/0x280
> > [111474.461594]  [<ffffffff811704bd>] ? vfs_ioctl+0x1d/0x50
> > [111474.461596]  [<ffffffff81170f79>] ? do_vfs_ioctl+0x69/0x1d0
> > [111474.461598]  [<ffffffff81171174>] ? sys_ioctl+0x94/0xa0
> > [111474.461601]  [<ffffffff8100c002>] ? system_call_fastpath+0x16/0x1b
> > [111474.461603] ---[ end trace fb86611b81442165 ]---
> > [111474.464580] iwlagn 0000:03:00.0: Error: Response NULL in 'REPLY_ADD_STA'
> > [111474.464586] iwlagn 0000:03:00.0: Adding station ff:ff:ff:ff:ff:ff failed.
> > [111474.472777] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111474.542468] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111474.543552] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111474.543809] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111475.894906] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111475.959248] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111475.960079] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111475.960195] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111477.339405] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111477.386319] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111477.387069] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111477.387213] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111478.700588] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111478.753591] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111478.754417] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111478.791333] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111480.192722] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111480.249724] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111480.250545] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111480.250695] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111481.654631] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111481.696438] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111481.697237] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111481.755643] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111483.016561] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111483.073672] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111483.074542] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111483.084848] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111484.463193] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111484.510342] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111484.511087] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111484.515897] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111485.930848] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111485.987148] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111485.988018] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111485.988177] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111487.369539] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111487.423704] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111487.424479] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111487.424621] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111488.796752] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111488.850445] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111488.851280] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111488.851502] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111490.271484] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111490.307285] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111490.308059] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111490.342785] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111491.678358] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111491.744236] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111491.745065] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111491.773720] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111493.205384] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111493.250872] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111493.251799] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111493.307372] wlan0: No active IBSS STAs - trying to scan for other
> > IBSS networks with same SSID (merge)
> > [111494.660506] wlan0: Selected IBSS BSSID 86:9f:24:fb:b0:44 based on
> > configured SSID
> > [111494.717399] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111494.718199] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111496.047915] wlan0: Trigger new scan to find an IBSS to join
> > [111501.880336] wlan0: Trigger new scan to find an IBSS to join
> > [111504.990820] wlan0: Creating new IBSS network, BSSID be:c7:fe:1c:61:99
> > [111505.034037] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111505.034743] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111506.404722] wlan0: Trigger new scan to find an IBSS to join
> > [111511.567631] wlan0: Trigger new scan to find an IBSS to join
> > [111514.702225] wlan0: Creating new IBSS network, BSSID 46:d5:59:b4:0b:54
> > [111514.752202] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111514.753078] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111516.083283] wlan0: Trigger new scan to find an IBSS to join
> > [111521.585645] wlan0: Trigger new scan to find an IBSS to join
> > [111524.617640] wlan0: Creating new IBSS network, BSSID b6:ca:41:c0:3e:bd
> > [111524.660101] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111524.661059] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111525.980241] wlan0: Trigger new scan to find an IBSS to join
> > [111531.296978] wlan0: Trigger new scan to find an IBSS to join
> > [111534.328992] wlan0: Creating new IBSS network, BSSID d6:00:8a:56:93:99
> > [111534.379572] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111534.380379] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111535.712405] wlan0: Trigger new scan to find an IBSS to join
> > [111541.621646] wlan0: Trigger new scan to find an IBSS to join
> > [111544.755981] wlan0: Creating new IBSS network, BSSID 72:06:bb:e2:44:34
> > [111544.817710] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111544.818623] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111546.186140] wlan0: Trigger new scan to find an IBSS to join
> > [111551.332991] wlan0: Trigger new scan to find an IBSS to join
> > [111554.467270] wlan0: Creating new IBSS network, BSSID 2a:49:ae:30:50:9e
> > [111554.533525] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111554.534350] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111555.904319] wlan0: Trigger new scan to find an IBSS to join
> > [111561.555433] wlan0: Trigger new scan to find an IBSS to join
> > [111564.587401] wlan0: Creating new IBSS network, BSSID aa:87:38:e5:ae:c0
> > [111564.661200] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111564.662171] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111565.981796] wlan0: Trigger new scan to find an IBSS to join
> > [111568.625818] iwlagn 0000:03:00.0: failed to remove IBSS station
> > 00:00:00:00:00:00
> > [111631.701608] ADDRCONF(NETDEV_UP): wlan0: link is not ready
> > [111631.829391] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
> > [111631.833307] wlan0: Trigger new scan to find an IBSS to join
> > [111634.393859] iwlagn 0000:03:00.0: failed to remove IBSS station
> > 00:00:00:00:00:00
> > [111634.705546] wlan0: Trigger new scan to find an IBSS to join
> > [111639.969168] wlan0: Trigger new scan to find an IBSS to join
> > [111642.456143] wlan0: no IPv6 routers present
> > [111643.095083] wlan0: Creating new IBSS network, BSSID ce:27:15:66:ab:a8
> > [111643.095541] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111643.096508] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111644.424790] wlan0: Trigger new scan to find an IBSS to join
> > [111649.672932] wlan0: Trigger new scan to find an IBSS to join
> > [111652.806533] wlan0: Creating new IBSS network, BSSID fe:a3:87:bf:ed:2f
> > [111652.812108] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111652.813077] iwlagn 0000:03:00.0: Unable to find TIM Element in beacon
> > [111654.639431] iwlagn 0000:03:00.0: Error sending
> > REPLY_TX_POWER_DBM_CMD: time out after 500ms.
> > [111654.639443] iwlagn 0000:03:00.0: Error sending TX power (-110)
> > [111654.639447] ------------[ cut here ]------------
> > [111654.639477] WARNING: at
> > /home/kernel-ppa/COD/linux/drivers/net/wireless/iwlwifi/iwl-core.c:1898
> > iwl_mac_change_interface+0x12e/0x130 [iwlcore]()
> > [111654.639482] Hardware name: 4384BB3
> > [111654.639484] Modules linked in: nf_nat_h323 nf_conntrack_h323
> > nf_nat_pptp nf_conntrack_pptp nf_conntrack_proto_gre nf_nat_proto_gre
> > nf_nat_tftp nf_conntrack_tftp nf_nat_sip nf_conntrack_sip nf_nat_irc
> > nf_nat_ftp cdc_acm usbhid hid xt_limit xt_tcpudp ipt_LOG
> > ipt_MASQUERADE xt_DSCP ipt_REJECT nf_conntrack_irc nf_conntrack_ftp
> > xt_state nls_iso8859_1 nls_cp437 vfat fat binfmt_misc vboxnetadp
> > vboxnetflt vboxdrv microcode parport_pc ppdev iptable_nat nf_nat
> > nf_conntrack_ipv4 nf_conntrack nf_defrag_ipv4 iptable_mangle
> > iptable_filter ip_tables x_tables uvcvideo snd_hda_codec_hdmi
> > snd_hda_codec_conexant arc4 videodev v4l2_compat_ioctl32 snd_hda_intel
> > snd_hda_codec snd_hwdep joydev snd_pcm hdaps thinkpad_ec iwlagn
> > snd_seq_midi iwlcore psmouse snd_rawmidi snd_seq_midi_event mac80211
> > snd_seq serio_raw tpm_tis tpm lp parport thinkpad_acpi tpm_bios nvram
> > snd_timer snd_seq_device cfg80211 snd intel_ips soundcore
> > snd_page_alloc sha256_generic aesni_intel cryptd aes_x86_64
> > aes_generic dm_crypt usb_storage uas i915 ahci drm_kms_helper
> > firewire_ohci e1000e libahci sdhci_pci firewire_core drm sdhci
> > crc_itu_t i2c_algo_bit video
> > [111654.639584] Pid: 1317, comm: wpa_supplicant Tainted: G        W
> > 2.6.38-020638rc7-generic #201103020909
> > [111654.639586] Call Trace:
> > [111654.639594]  [<ffffffffa02e6c7e>] ?
> > iwl_mac_change_interface+0x12e/0x130 [iwlcore]
> > [111654.639599]  [<ffffffffa02e6c7e>] ?
> > iwl_mac_change_interface+0x12e/0x130 [iwlcore]
> > [111654.639605]  [<ffffffff81065430>] ? warn_slowpath_common+0x90/0xc0
> > [111654.639608]  [<ffffffff8106547a>] ? warn_slowpath_null+0x1a/0x20
> > [111654.639612]  [<ffffffffa02e6c7e>] ?
> > iwl_mac_change_interface+0x12e/0x130 [iwlcore]
> > [111654.639626]  [<ffffffffa02869ec>] ?
> > ieee80211_runtime_change_iftype+0xdc/0x180 [mac80211]
> > [111654.639633]  [<ffffffffa0286b85>] ?
> > ieee80211_if_change_type+0xf5/0x120 [mac80211]
> > [111654.639641]  [<ffffffffa028995b>] ?
> > ieee80211_change_iface+0x3b/0x130 [mac80211]
> > [111654.639650]  [<ffffffffa01bf898>] ?
> > cfg80211_change_iface+0xe8/0x1c0 [cfg80211]
> > [111654.639657]  [<ffffffffa01d78f6>] ?
> > cfg80211_wext_siwmode+0xa6/0xf0 [cfg80211]
> > [111654.639661]  [<ffffffff8158a4cb>] ? ioctl_standard_call+0x6b/0xf0
> > [111654.639664]  [<ffffffff8158a460>] ? ioctl_standard_call+0x0/0xf0
> > [111654.639666]  [<ffffffff81589882>] ? wireless_process_ioctl+0x102/0x130
> > [111654.639668]  [<ffffffff8158afe0>] ? ioctl_private_call+0x0/0xa0
> > [111654.639670]  [<ffffffff8158afe0>] ? ioctl_private_call+0x0/0xa0
> > [111654.639672]  [<ffffffff8158a460>] ? ioctl_standard_call+0x0/0xf0
> > [111654.639675]  [<ffffffff8158991c>] ? wext_ioctl_dispatch+0x6c/0x90
> > [111654.639677]  [<ffffffff81589b66>] ? wext_handle_ioctl+0x46/0x90
> > [111654.639680]  [<ffffffff814ad76a>] ? sockfd_lookup_light+0x4a/0x80
> > [111654.639683]  [<ffffffff814c687b>] ? dev_ioctl+0x28b/0x2a0
> > [111654.639685]  [<ffffffff814ad25f>] ? sock_ioctl+0xbf/0x280
> > [111654.639688]  [<ffffffff811704bd>] ? vfs_ioctl+0x1d/0x50
> > [111654.639690]  [<ffffffff81170f79>] ? do_vfs_ioctl+0x69/0x1d0
> > [111654.639692]  [<ffffffff81171174>] ? sys_ioctl+0x94/0xa0
> > [111654.639695]  [<ffffffff8100c002>] ? system_call_fastpath+0x16/0x1b
> > [111654.639697] ---[ end trace fb86611b81442166 ]---
> >
> > I think the crash happens when the phone attempts to get an IP, at
> > least that's what the phone says right after/at the crash. Any ideas?
> >
> > // Mathias
> > --
> > To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> > the body of a message to majordomo@vger.kernel.org
> > More majordomo info at  http://vger.kernel.org/majordomo-info.html
> > Please read the FAQ at  http://www.tux.org/lkml/
> >
> 
> --
> John W. Linville                Someday the world will need a hero, and you
> linville@tuxdriver.com                  might be all we have.  Be ready.


