Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684Ab2A3P5C (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jan 2012 10:57:02 -0500
Received: from mga11.intel.com ([192.55.52.93]:65109 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753196Ab2A3P5A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jan 2012 10:57:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="112078090"
From: "Guy, Wey-Yi W" <wey-yi.w.guy@intel.com>
To: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
CC: Intel Linux Wireless <ilw@linux.intel.com>
Subject: RE: 3.3.0-rc1+ (Linus GIT) - iwlwifi losing connection regularly.
Thread-Topic: 3.3.0-rc1+ (Linus GIT) - iwlwifi losing connection regularly.
Thread-Index: AQHM3rcWAUwsjiXoh0OYDF4qFw62i5YlEfjg
Date: Mon, 30 Jan 2012 15:56:55 +0000
Message-ID: <5D69FF551B764E40A8245E579F3F73E60210736F@ORSMSX102.amr.corp.intel.com>
References: <CAHFgRy-1519kkWwBxfe8UZMcOHqrbiq34dTX-wN5a+pd_4GPSA@mail.gmail.com>
In-Reply-To: <CAHFgRy-1519kkWwBxfe8UZMcOHqrbiq34dTX-wN5a+pd_4GPSA@mail.gmail.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: yes
X-MS-TNEF-Correlator: 
x-originating-ip: [10.22.254.139]
Content-Type: multipart/mixed;
	boundary="_002_5D69FF551B764E40A8245E579F3F73E60210736FORSMSX102amrcor_"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

--_002_5D69FF551B764E40A8245E579F3F73E60210736FORSMSX102amrcor_
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable

Could you give this patch a try?

Thanks
Wey


-----Original Message-----
From: Miles Lane [mailto:miles.lane@gmail.com]=20
Sent: Sunday, January 29, 2012 10:52 AM
To: LKML
Cc: Intel Linux Wireless; Guy, Wey-Yi W
Subject: 3.3.0-rc1+ (Linus GIT) - iwlwifi losing connection regularly.

Hello,

I find that with builds of Linus GIT over the last week or so I need
to rmmod and insmod the iwlwifi driver about once every ten minutes.
When the connection stops working, networkmanager still shows the
connection as active, but no data is getting through (Web, pings,
etc).
I enabled full debug output and here is a sample of kern.log that
stretches from a point in time when the connection was working through
past when it failed.
Please let me know if I can help debug this further.  I don't have
time to do a bisection, unfortunately.

[ 3518.943239] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3518.943246] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 53, i =3D 51,
REPLY_RX_PHY_CMD, 0xc0
[ 3518.943254] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 53, i =3D 52,
REPLY_RX_MPDU_CMD, 0xc1
[ 3518.943260] iwlwifi 0000:03:00.0: I iwlagn_translate_rx_status
decrypt_in:0xe56a5f =A0decrypt_out =3D 0x1ac0
[ 3518.943266] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag
decrypt_res:0x1ac0
[ 3518.943270] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag hw
decrypt successfully!!!
[ 3518.943326] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3518.950012] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 831 value
0x00148000
[ 3518.950019] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3518.950052] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3518.950054]
[ 3518.950058] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3518.950064] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 55, i =3D 53,
REPLY_RX_PHY_CMD, 0xc0
[ 3518.950071] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 55, i =3D 54,
REPLY_RX_MPDU_CMD, 0xc1
[ 3518.950076] iwlwifi 0000:03:00.0: I iwlagn_translate_rx_status
decrypt_in:0xe56a5f =A0decrypt_out =3D 0x1ac0
[ 3518.950081] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag
decrypt_res:0x1ac0
[ 3518.950085] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag hw
decrypt successfully!!!
[ 3518.950129] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3518.953532] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 832 value
0x00148000
[ 3518.953539] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3518.953572] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3518.953574]
[ 3518.953578] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3518.953585] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 57, i =3D 55,
REPLY_RX_PHY_CMD, 0xc0
[ 3518.953592] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 57, i =3D 56,
REPLY_RX_MPDU_CMD, 0xc1
[ 3518.953598] iwlwifi 0000:03:00.0: I iwlagn_translate_rx_status
decrypt_in:0xe56a5f =A0decrypt_out =3D 0x1ac0
[ 3518.953604] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag
decrypt_res:0x1ac0
[ 3518.953609] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag hw
decrypt successfully!!!
[ 3518.953654] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3518.956737] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 833 value
0x00148000
[ 3518.956744] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3518.956777] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3518.956779]
[ 3518.956783] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3518.956790] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 59, i =3D 57,
REPLY_RX_PHY_CMD, 0xc0
[ 3518.956797] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 59, i =3D 58,
REPLY_RX_MPDU_CMD, 0xc1
[ 3518.956803] iwlwifi 0000:03:00.0: I iwlagn_translate_rx_status
decrypt_in:0xe56a5f =A0decrypt_out =3D 0x1ac0
[ 3518.956808] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag
decrypt_res:0x1ac0
[ 3518.956813] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag hw
decrypt successfully!!!
[ 3518.956904] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3518.960498] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 834 value
0x00148000
[ 3518.960506] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3518.960539] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3518.960541]
[ 3518.960546] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3518.960552] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 61, i =3D 59,
REPLY_RX_PHY_CMD, 0xc0
[ 3518.960560] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 61, i =3D 60,
REPLY_RX_MPDU_CMD, 0xc1
[ 3518.960566] iwlwifi 0000:03:00.0: I iwlagn_translate_rx_status
decrypt_in:0xe56a5f =A0decrypt_out =3D 0x1ac0
[ 3518.960571] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag
decrypt_res:0x1ac0
[ 3518.960575] iwlwifi 0000:03:00.0: I iwlagn_set_decrypted_flag hw
decrypt successfully!!!
[ 3518.960628] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3518.970498] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 835 value
0x00001000
[ 3518.970505] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3518.970538] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3518.970540]
[ 3518.970544] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3518.970549] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 61, i =3D 61
[ 3518.970555] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.004305] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 836 value
0x00148000
[ 3519.004312] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 837 value
0x00148000
[ 3519.004317] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.004348] iwlwifi 0000:03:00.0: I iwl_isr_ict Ignore interrupt, inta =
=3D=3D 0
[ 3519.004378] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.004380]
[ 3519.004384] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.004391] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 64, i =3D 61,
REPLY_RX_PHY_CMD, 0xc0
[ 3519.004399] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 64, i =3D 62,
REPLY_RX_MPDU_CMD, 0xc1
[ 3519.004449] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 64, i =3D 63,
STATISTICS_NOTIFICATION, 0x9d
[ 3519.004455] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3519.004466] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 18, b 0, c 0, dBm -89
[ 3519.004481] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.004502] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102376 usecs
[ 3519.004509] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 0 =A0ofdm: fa 0 badp 2
[ 3519.004515] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
409600 < min FA 511880
[ 3519.004521] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
16, b 0, c 0, 20-bcn max 23
[ 3519.004527] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
69, b 94, c 94, 10-bcn max/min 70
[ 3519.004532] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 1
[ 3519.004538] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA 0 <
min FA 511880, silence diff 0
[ 3519.004543] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3519.004548] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3519.004554] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3519.004560] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3519.004565] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3519.014350] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 838 value
0x00001000
[ 3519.014357] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3519.014391] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3519.014393]
[ 3519.014397] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.014402] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 64, i =3D 64
[ 3519.014407] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.209124] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 839 value
0x00148000
[ 3519.209131] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 840 value
0x00148000
[ 3519.209137] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.209168] iwlwifi 0000:03:00.0: I iwl_isr_ict Ignore interrupt, inta =
=3D=3D 0
[ 3519.209201] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.209203]
[ 3519.209207] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.209214] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 67, i =3D 64,
REPLY_RX_PHY_CMD, 0xc0
[ 3519.209222] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 67, i =3D 65,
REPLY_RX_MPDU_CMD, 0xc1
[ 3519.209277] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 67, i =3D 66,
STATISTICS_NOTIFICATION, 0x9d
[ 3519.209283] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3519.209294] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 19, b 0, c 0, dBm -88
[ 3519.209340] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.209379] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 204814 usecs
[ 3519.209387] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 1 =A0ofdm: fa 1 badp 0
[ 3519.209393] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
204800 < min FA 1024070
[ 3519.209399] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
17, b 0, c 0, 20-bcn max 23
[ 3519.209405] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
71, b 93, c 93, 10-bcn max/min 71
[ 3519.209410] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 2
[ 3519.209415] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
204800 < min FA 1024070, silence diff 0
[ 3519.209420] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3519.209425] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3519.209431] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3519.209436] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3519.209441] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3519.219195] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 841 value
0x00001000
[ 3519.219203] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3519.219237] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3519.219239]
[ 3519.219243] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.219248] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 67, i =3D 67
[ 3519.219254] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.312547] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 842 value
0x00148000
[ 3519.312555] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.312588] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.312590]
[ 3519.312594] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.312601] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 70, i =3D 67,
REPLY_RX_PHY_CMD, 0xc0
[ 3519.312610] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 70, i =3D 68,
REPLY_RX_MPDU_CMD, 0xc1
[ 3519.312664] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 70, i =3D 69,
STATISTICS_NOTIFICATION, 0x9d
[ 3519.312670] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3519.312677] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 18, b 0, c 0, dBm -89
[ 3519.312696] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.312714] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 103418 usecs
[ 3519.312722] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 0 =A0ofdm: fa 0 badp 0
[ 3519.312728] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 517090
[ 3519.312734] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
15, b 0, c 0, 20-bcn max 23
[ 3519.312739] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
70, b 91, c 91, 10-bcn max/min 71
[ 3519.312745] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 3
[ 3519.312751] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA 0 <
min FA 517090, silence diff 0
[ 3519.312756] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3519.312761] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3519.312766] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3519.312773] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3519.312778] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3519.313248] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 843 value
0x00148000
[ 3519.313253] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.313285] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.313287]
[ 3519.313291] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.313297] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 71, i =3D 70,
MISSED_BEACONS_NOTIFICATION, 0xa2
[ 3519.313303] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.323169] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 844 value
0x00001000
[ 3519.323177] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3519.323210] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3519.323212]
[ 3519.323217] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.323222] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 71, i =3D 71
[ 3519.323227] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.413902] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 845 value
0x00148000
[ 3519.413910] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.413942] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.413944]
[ 3519.413948] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.413956] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 74, i =3D 71,
REPLY_RX_PHY_CMD, 0xc0
[ 3519.413964] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 74, i =3D 72,
REPLY_RX_MPDU_CMD, 0xc1
[ 3519.414018] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 74, i =3D 73,
STATISTICS_NOTIFICATION, 0x9d
[ 3519.414024] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3519.414036] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 18, b 0, c 0, dBm -89
[ 3519.414080] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.414122] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 101344 usecs
[ 3519.414130] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 1 =A0ofdm: fa 0 badp 0
[ 3519.414136] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 506720
[ 3519.414141] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
15, b 0, c 0, 20-bcn max 22
[ 3519.414147] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
69, b 94, c 94, 10-bcn max/min 71
[ 3519.414152] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 4
[ 3519.414158] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
204800 < min FA 506720, silence diff 1
[ 3519.414163] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3519.414167] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3519.414173] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3519.414179] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3519.414184] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3519.423930] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 846 value
0x00001000
[ 3519.423937] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3519.423970] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3519.423973]
[ 3519.423977] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.423983] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 74, i =3D 74
[ 3519.423988] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.469728] iwlwifi 0000:03:00.0: I rs_get_rate rate scale
calculate new rate for skb
[ 3519.469741] iwlwifi 0000:03:00.0: I iwlagn_mac_tx dev->xmit(70
bytes) at rate 0x5a
[ 3519.469749] iwlwifi 0000:03:00.0: I iwlagn_tx_skb station Id 0
[ 3519.469756] iwlwifi 0000:03:00.0: I iwlagn_tx_cmd_build_hwcrypto
tx_cmd with AES hwcrypto
[ 3519.469765] iwlwifi 0000:03:00.0: I iwl_trans_pcie_tx sequence nr =3D 0X=
cf4
[ 3519.469770] iwlwifi 0000:03:00.0: I iwl_trans_pcie_tx tx_flags =3D 0X500=
019
[ 3519.469775] iwl data: 00000000: 46 00 00 00 19 00 50 00 00 00 00 00
00 00 00 00 =A0F.....P.........
[ 3519.469779] iwl data: 00000010: 00 02 00 00 63 17 a2 17 f0 79 36 f7
ad ea 16 94 =A0....c....y6.....
[ 3519.469784] iwl data: 00000020: 61 39 70 00 00 00 00 00 ff ff ff ff
9c 62 c0 5a =A0a9p..........b.Z
[ 3519.469788] iwl data: 00000030: 00 3c 0f 00 00 00 00 00
=A0 =A0 =A0 =A0 =A0 =A0 =A0.<......
[ 3519.469792] iwl data: 00000000: 88 41 00 00 00 23 69 be f3 e2 00 1e
64 06 05 96 =A0.A...#i.....d...
[ 3519.469796] iwl data: 00000010: ff ff ff ff ff ff 40 0f 00 00
=A0 =A0 =A0 =A0 =A0 =A0 =A0......@...
[ 3519.516296] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 847 value
0x00148000
[ 3519.516304] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.516337] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.516339]
[ 3519.516370] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.516378] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 77, i =3D 74,
REPLY_RX_PHY_CMD, 0xc0
[ 3519.516387] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 77, i =3D 75,
REPLY_RX_MPDU_CMD, 0xc1
[ 3519.516436] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 77, i =3D 76,
STATISTICS_NOTIFICATION, 0x9d
[ 3519.516442] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3519.516450] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 18, b 0, c 0, dBm -89
[ 3519.516463] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.517316] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102395 usecs
[ 3519.517323] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 0 =A0ofdm: fa 0 badp 0
[ 3519.517329] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511975
[ 3519.517335] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
16, b 0, c 0, 20-bcn max 22
[ 3519.517341] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
71, b 94, c 94, 10-bcn max/min 71
[ 3519.517346] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 5
[ 3519.517352] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA 0 <
min FA 511975, silence diff 1
[ 3519.517357] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3519.517362] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3519.517368] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3519.517374] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3519.517379] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3519.526327] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 848 value
0x00001000
[ 3519.526327] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3519.526409] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3519.526412]
[ 3519.526417] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.526423] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 77, i =3D 77
[ 3519.526429] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.721098] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 849 value
0x00148000
[ 3519.721106] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.721139] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.721141]
[ 3519.721145] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.721152] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 80, i =3D 77,
REPLY_RX_PHY_CMD, 0xc0
[ 3519.721161] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 80, i =3D 78,
REPLY_RX_MPDU_CMD, 0xc1
[ 3519.721219] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 80, i =3D 79,
STATISTICS_NOTIFICATION, 0x9d
[ 3519.721225] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3519.721236] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 21, b 0, c 0, dBm -86
[ 3519.721252] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.721259] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 204773 usecs
[ 3519.721267] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 11 =A0ofdm: fa 2 badp 2
[ 3519.721274] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
819200 < min FA 1023865
[ 3519.721279] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
19, b 0, c 0, 20-bcn max 22
[ 3519.721285] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
71, b 95, c 95, 10-bcn max/min 71
[ 3519.721290] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3519.721295] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3519.721300] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3519.721306] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3519.721312] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3519.721318] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3519.731123] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 850 value
0x00001000
[ 3519.731131] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3519.731165] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3519.731167]
[ 3519.731171] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.731177] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 80, i =3D 80
[ 3519.731182] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.823517] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 851 value
0x00148000
[ 3519.823525] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.823558] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.823560]
[ 3519.823565] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.823572] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 83, i =3D 80,
REPLY_RX_PHY_CMD, 0xc0
[ 3519.823581] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 83, i =3D 81,
REPLY_RX_MPDU_CMD, 0xc1
[ 3519.823634] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 83, i =3D 82,
STATISTICS_NOTIFICATION, 0x9d
[ 3519.823640] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3519.823652] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 17, b 0, c 0, dBm -90
[ 3519.823697] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.823748] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102408 usecs
[ 3519.823755] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 0 =A0ofdm: fa 0 badp 0
[ 3519.823760] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 512040
[ 3519.823766] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
16, b 0, c 0, 20-bcn max 22
[ 3519.823771] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
71, b 94, c 94, 10-bcn max/min 71
[ 3519.823776] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 1
[ 3519.823781] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA 0 <
min FA 512040, silence diff 0
[ 3519.823786] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3519.823791] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3519.823797] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3519.823802] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3519.823807] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3519.825245] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 852 value
0x00148000
[ 3519.825252] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.825284] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.825285]
[ 3519.825289] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.825295] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 84, i =3D 83,
MISSED_BEACONS_NOTIFICATION, 0xa2
[ 3519.825302] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.835179] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 853 value
0x00001000
[ 3519.835187] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3519.835220] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3519.835222]
[ 3519.835226] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.835231] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 84, i =3D 84
[ 3519.835237] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.925893] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 854 value
0x00148000
[ 3519.925901] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 855 value
0x00148000
[ 3519.925906] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3519.925937] iwlwifi 0000:03:00.0: I iwl_isr_ict Ignore interrupt, inta =
=3D=3D 0
[ 3519.925968] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.925970]
[ 3519.925974] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.925982] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 87, i =3D 84,
REPLY_RX_PHY_CMD, 0xc0
[ 3519.925990] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 87, i =3D 85,
REPLY_RX_MPDU_CMD, 0xc1
[ 3519.926048] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 87, i =3D 86,
STATISTICS_NOTIFICATION, 0x9d
[ 3519.926054] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3519.926062] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 18, b 0, c 0, dBm -89
[ 3519.926081] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.926088] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102376 usecs
[ 3519.926096] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 4 =A0ofdm: fa 0 badp 1
[ 3519.926102] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
204800 < min FA 511880
[ 3519.926107] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
16, b 0, c 0, 20-bcn max 22
[ 3519.926113] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
71, b 94, c 94, 10-bcn max/min 71
[ 3519.926118] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3519.926123] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3519.926127] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3519.926133] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3519.926139] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3519.926145] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3519.928336] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 856 value
0x00048000
[ 3519.928343] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3519.928376] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3519.928379]
[ 3519.928382] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.928389] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 88, i =3D 87,
REPLY_RX_PHY_CMD, 0xc0
[ 3519.928396] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3519.938262] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 857 value
0x00001000
[ 3519.938270] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3519.938303] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3519.938305]
[ 3519.938309] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3519.938315] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 88, i =3D 88
[ 3519.938320] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.028292] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 858 value
0x00148000
[ 3520.028300] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 859 value
0x00148000
[ 3520.028305] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.028335] iwlwifi 0000:03:00.0: I iwl_isr_ict Ignore interrupt, inta =
=3D=3D 0
[ 3520.028365] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.028367]
[ 3520.028371] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.028379] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 91, i =3D 88,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.028387] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 91, i =3D 89,
REPLY_RX_MPDU_CMD, 0xc1
[ 3520.028448] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 91, i =3D 90,
STATISTICS_NOTIFICATION, 0x9d
[ 3520.028454] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3520.028465] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 19, b 0, c 0, dBm -88
[ 3520.028510] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.028559] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102395 usecs
[ 3520.028565] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 0 =A0ofdm: fa 0 badp 0
[ 3520.028571] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511975
[ 3520.028576] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
18, b 0, c 0, 20-bcn max 20
[ 3520.028582] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
62, b 86, c 86, 10-bcn max/min 71
[ 3520.028587] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 1
[ 3520.028593] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA 0 <
min FA 511975, silence diff 2
[ 3520.028598] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3520.028602] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3520.028608] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3520.028614] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3520.028619] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3520.038380] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 860 value
0x00001000
[ 3520.038389] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.038422] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.038424]
[ 3520.038428] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.038433] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 91, i =3D 91
[ 3520.038438] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.041116] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 861 value
0x00048000
[ 3520.041123] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3520.041156] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.041157]
[ 3520.041161] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.041168] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 92, i =3D 91,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.041176] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.051040] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 862 value
0x00001000
[ 3520.051048] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.051081] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.051083]
[ 3520.051087] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.051092] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 92, i =3D 92
[ 3520.051098] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.234391] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 863 value
0x00148000
[ 3520.234399] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 864 value
0x00148000
[ 3520.234405] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.234435] iwlwifi 0000:03:00.0: I iwl_isr_ict Ignore interrupt, inta =
=3D=3D 0
[ 3520.234466] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.234468]
[ 3520.234472] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.234479] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 95, i =3D 92,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.234488] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 95, i =3D 93,
REPLY_RX_MPDU_CMD, 0xc1
[ 3520.234542] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 95, i =3D 94,
STATISTICS_NOTIFICATION, 0x9d
[ 3520.234548] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3520.234558] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 24, b 0, c 0, dBm -83
[ 3520.234569] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.234614] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 206086 usecs
[ 3520.234621] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 1 =A0ofdm: fa 0 badp 1
[ 3520.234627] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
204800 < min FA 1030430
[ 3520.234632] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
21, b 0, c 0, 20-bcn max 21
[ 3520.234638] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
62, b 86, c 86, 10-bcn max/min 71
[ 3520.234643] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 2
[ 3520.234649] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
204800 < min FA 1030430, silence diff 1
[ 3520.234654] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3520.234659] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3520.234665] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3520.234671] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3520.234676] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3520.244443] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 865 value
0x00001000
[ 3520.244451] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.244485] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.244487]
[ 3520.244491] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.244497] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 95, i =3D 95
[ 3520.244502] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.335492] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 866 value
0x00148000
[ 3520.335500] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.335534] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.335536]
[ 3520.335540] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.335547] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 98, i =3D 95,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.335555] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 98, i =3D 96,
REPLY_RX_MPDU_CMD, 0xc1
[ 3520.335611] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 98, i =3D 97,
STATISTICS_NOTIFICATION, 0x9d
[ 3520.335617] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3520.335625] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 18, b 0, c 0, dBm -89
[ 3520.335669] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 101099 usecs
[ 3520.335677] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 0 =A0ofdm: fa 0 badp 0
[ 3520.335678] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.335687] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 505495
[ 3520.335693] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
18, b 0, c 0, 20-bcn max 21
[ 3520.335698] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
72, b 95, c 95, 10-bcn max/min 72
[ 3520.335704] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 3
[ 3520.335710] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA 0 <
min FA 505495, silence diff 1
[ 3520.335715] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3520.335720] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3520.335726] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3520.335732] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3520.335738] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3520.337239] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 867 value
0x00148000
[ 3520.337246] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.337279] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.337282]
[ 3520.337286] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.337292] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 99, i =3D 98,
MISSED_BEACONS_NOTIFICATION, 0xa2
[ 3520.337299] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.347163] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 868 value
0x00001000
[ 3520.347171] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.347204] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.347206]
[ 3520.347210] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.347215] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 99, i =3D 99
[ 3520.347220] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.437897] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 869 value
0x00148000
[ 3520.437906] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.437938] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.437941]
[ 3520.437945] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.437953] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 102, i =3D 99,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.437961] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 102, i =3D 100,
REPLY_RX_MPDU_CMD, 0xc1
[ 3520.438017] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 102, i =3D 101,
STATISTICS_NOTIFICATION, 0x9d
[ 3520.438024] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3520.438036] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 23, b 0, c 0, dBm -84
[ 3520.438047] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.438084] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102395 usecs
[ 3520.438092] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 0 =A0ofdm: fa 1 badp 0
[ 3520.438098] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
204800 < min FA 511975
[ 3520.438104] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
22, b 0, c 0, 20-bcn max 22
[ 3520.438110] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
62, b 86, c 86, 10-bcn max/min 72
[ 3520.438115] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 4
[ 3520.438120] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA 0 <
min FA 511975, silence diff 0
[ 3520.438125] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3520.438130] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3520.438136] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3520.438141] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3520.438146] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3520.447934] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 870 value
0x00001000
[ 3520.447942] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.447975] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.447977]
[ 3520.447981] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.447987] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 102, i =3D 102
[ 3520.447992] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.474096] iwlwifi 0000:03:00.0: I rs_get_rate rate scale
calculate new rate for skb
[ 3520.474116] iwlwifi 0000:03:00.0: I iwlagn_mac_tx dev->xmit(70
bytes) at rate 0x5a
[ 3520.474131] iwlwifi 0000:03:00.0: I iwlagn_tx_skb station Id 0
[ 3520.474148] iwlwifi 0000:03:00.0: I iwlagn_tx_cmd_build_hwcrypto
tx_cmd with AES hwcrypto
[ 3520.474157] iwlwifi 0000:03:00.0: I iwl_trans_pcie_tx sequence nr =3D 0X=
cf5
[ 3520.474161] iwlwifi 0000:03:00.0: I iwl_trans_pcie_tx tx_flags =3D 0X500=
019
[ 3520.474167] iwl data: 00000000: 46 00 00 00 19 00 50 00 00 00 00 00
00 00 00 00 =A0F.....P.........
[ 3520.474171] iwl data: 00000010: 00 02 00 00 63 17 a2 17 f0 79 36 f7
ad ea 16 94 =A0....c....y6.....
[ 3520.474176] iwl data: 00000020: 61 39 70 00 00 00 00 00 ff ff ff ff
e4 63 c0 5a =A0a9p..........c.Z
[ 3520.474180] iwl data: 00000030: 00 3c 0f 00 00 00 00 00
=A0 =A0 =A0 =A0 =A0 =A0 =A0.<......
[ 3520.474185] iwl data: 00000000: 88 41 00 00 00 23 69 be f3 e2 00 1e
64 06 05 96 =A0.A...#i.....d...
[ 3520.474189] iwl data: 00000010: ff ff ff ff ff ff 50 0f 00 00
=A0 =A0 =A0 =A0 =A0 =A0 =A0......P...
[ 3520.540297] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 871 value
0x00148000
[ 3520.540305] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.540338] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.540341]
[ 3520.540345] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.540352] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 105, i =3D 102,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.540361] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 105, i =3D 103,
REPLY_RX_MPDU_CMD, 0xc1
[ 3520.540415] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 105, i =3D 104,
STATISTICS_NOTIFICATION, 0x9d
[ 3520.540421] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3520.540429] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 18, b 0, c 0, dBm -89
[ 3520.540441] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.540496] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102391 usecs
[ 3520.540503] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 1 =A0ofdm: fa 0 badp 0
[ 3520.540509] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511955
[ 3520.540515] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
16, b 0, c 0, 20-bcn max 22
[ 3520.540521] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
72, b 95, c 95, 10-bcn max/min 72
[ 3520.540526] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 5
[ 3520.540532] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
204800 < min FA 511955, silence diff 0
[ 3520.540537] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3520.540542] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3520.540549] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3520.540555] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3520.540560] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3520.550313] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 872 value
0x00001000
[ 3520.550321] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.550354] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.550356]
[ 3520.550361] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.550366] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 105, i =3D 105
[ 3520.550371] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.642696] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 873 value
0x00148000
[ 3520.642704] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.642737] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.642739]
[ 3520.642743] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.642751] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 108, i =3D 105,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.642759] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 108, i =3D 106,
REPLY_RX_MPDU_CMD, 0xc1
[ 3520.642812] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 108, i =3D 107,
STATISTICS_NOTIFICATION, 0x9d
[ 3520.642818] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3520.642830] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 20, b 0, c 0, dBm -87
[ 3520.642875] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.642917] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102392 usecs
[ 3520.642925] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 2 =A0ofdm: fa 0 badp 3
[ 3520.642932] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm min FA
511960 < norm FA 614400 < max FA 5119600 OK
[ 3520.642938] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
18, b 0, c 0, 20-bcn max 22
[ 3520.642943] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
63, b 86, c 86, 10-bcn max/min 72
[ 3520.642948] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 6
[ 3520.642954] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
409600 < min FA 511960, silence diff 0
[ 3520.642959] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3520.642963] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3520.642969] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3520.642975] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3520.642980] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3520.652725] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 874 value
0x00001000
[ 3520.652733] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.652767] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.652769]
[ 3520.652773] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.652779] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 108, i =3D 108
[ 3520.652784] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.745199] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 875 value
0x00148000
[ 3520.745208] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.745241] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.745243]
[ 3520.745247] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.745255] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 111, i =3D 108,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.745263] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 111, i =3D 109,
REPLY_RX_MPDU_CMD, 0xc1
[ 3520.745314] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 111, i =3D 110,
STATISTICS_NOTIFICATION, 0x9d
[ 3520.745320] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3520.745328] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 19, b 0, c 0, dBm -88
[ 3520.745340] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.745422] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102503 usecs
[ 3520.745430] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 3 =A0ofdm: fa 0 badp 0
[ 3520.745436] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 512515
[ 3520.745442] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
17, b 0, c 0, 20-bcn max 22
[ 3520.745448] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
62, b 86, c 86, 10-bcn max/min 72
[ 3520.745453] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3520.745458] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3520.745463] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3520.745469] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3520.745475] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3520.745480] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3520.755206] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 876 value
0x00001000
[ 3520.755214] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.755248] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.755249]
[ 3520.755254] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.755259] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 111, i =3D 111
[ 3520.755264] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.847692] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 877 value
0x00148000
[ 3520.847700] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.847732] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.847734]
[ 3520.847738] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.847745] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 114, i =3D 111,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.847753] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 114, i =3D 112,
REPLY_RX_MPDU_CMD, 0xc1
[ 3520.847805] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 114, i =3D 113,
STATISTICS_NOTIFICATION, 0x9d
[ 3520.847811] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3520.847822] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 19, b 0, c 0, dBm -88
[ 3520.847866] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.847921] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102480 usecs
[ 3520.847927] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 0 =A0ofdm: fa 0 badp 0
[ 3520.847933] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 512400
[ 3520.847939] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
17, b 0, c 0, 20-bcn max 22
[ 3520.847944] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
72, b 95, c 95, 10-bcn max/min 72
[ 3520.847949] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 1
[ 3520.847955] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA 0 <
min FA 512400, silence diff 0
[ 3520.847960] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3520.847964] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3520.847970] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3520.847976] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3520.847981] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3520.849256] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 878 value
0x00148000
[ 3520.849263] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.849294] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.849296]
[ 3520.849300] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.849306] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 115, i =3D 114,
MISSED_BEACONS_NOTIFICATION, 0xa2
[ 3520.849312] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.859172] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 879 value
0x00001000
[ 3520.859180] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.859214] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.859215]
[ 3520.859220] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.859225] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 115, i =3D 115
[ 3520.859230] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.949914] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 880 value
0x00148000
[ 3520.949922] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3520.949955] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3520.949957]
[ 3520.949961] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.949969] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 118, i =3D 115,
REPLY_RX_PHY_CMD, 0xc0
[ 3520.949977] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 118, i =3D 116,
REPLY_RX_MPDU_CMD, 0xc1
[ 3520.950031] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 118, i =3D 117,
STATISTICS_NOTIFICATION, 0x9d
[ 3520.950037] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3520.950044] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 20, b 0, c 0, dBm -87
[ 3520.950061] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3520.950080] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102214 usecs
[ 3520.950086] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 1 =A0ofdm: fa 0 badp 0
[ 3520.950092] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511070
[ 3520.950098] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
18, b 0, c 0, 20-bcn max 22
[ 3520.950103] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
63, b 86, c 86, 10-bcn max/min 72
[ 3520.950108] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 2
[ 3520.950113] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
204800 < min FA 511070, silence diff 0
[ 3520.950118] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3520.950123] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3520.950129] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3520.950135] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3520.950139] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3520.959931] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 881 value
0x00001000
[ 3520.959938] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3520.959971] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3520.959973]
[ 3520.959977] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3520.959982] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 118, i =3D 118
[ 3520.959988] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.052305] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 882 value
0x00148000
[ 3521.052314] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.052347] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.052349]
[ 3521.052353] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.052361] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 121, i =3D 118,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.052371] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 121, i =3D 119,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.052426] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 121, i =3D 120,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.052432] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.052439] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 27, b 0, c 0, dBm -80
[ 3521.052455] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.052462] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102388 usecs
[ 3521.052470] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 3 =A0ofdm: fa 0 badp 0
[ 3521.052477] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511940
[ 3521.052482] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
28, b 0, c 0, 20-bcn max 28
[ 3521.052488] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
63, b 87, c 87, 10-bcn max/min 72
[ 3521.052494] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.052499] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3521.052504] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3521.052510] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.052516] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3521.052521] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3521.062328] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 883 value
0x00001000
[ 3521.062336] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.062369] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.062371]
[ 3521.062375] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.062381] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 121, i =3D 121
[ 3521.062387] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.154689] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 884 value
0x00148000
[ 3521.154697] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.154731] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.154733]
[ 3521.154737] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.154744] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 124, i =3D 121,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.154753] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 124, i =3D 122,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.154808] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 124, i =3D 123,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.154813] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.154824] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 21, b 0, c 0, dBm -86
[ 3521.154869] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.154913] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102371 usecs
[ 3521.154921] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 6 =A0ofdm: fa 0 badp 2
[ 3521.154927] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
409600 < min FA 511855
[ 3521.154933] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
21, b 0, c 0, 20-bcn max 28
[ 3521.154939] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
72, b 96, c 96, 10-bcn max/min 72
[ 3521.154944] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.154950] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3521.154954] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3521.154960] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.154966] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3521.154971] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3521.164720] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 885 value
0x00001000
[ 3521.164727] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.164760] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.164762]
[ 3521.164766] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.164772] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 124, i =3D 124
[ 3521.164777] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.257085] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 886 value
0x00148000
[ 3521.257093] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.257127] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.257130]
[ 3521.257134] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.257141] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 127, i =3D 124,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.257150] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 127, i =3D 125,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.257209] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 127, i =3D 126,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.257215] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.257223] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 22, b 0, c 0, dBm -85
[ 3521.257235] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.257282] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102393 usecs
[ 3521.257288] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 4 =A0ofdm: fa 0 badp 0
[ 3521.257294] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511965
[ 3521.257300] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
21, b 0, c 0, 20-bcn max 28
[ 3521.257306] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
72, b 96, c 96, 10-bcn max/min 72
[ 3521.257311] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.257316] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3521.257321] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3521.257327] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.257334] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3521.257339] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3521.267108] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 887 value
0x00001000
[ 3521.267117] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.267150] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.267152]
[ 3521.267157] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.267162] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 127, i =3D 127
[ 3521.267168] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.359485] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 888 value
0x00148000
[ 3521.359494] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.359527] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.359529]
[ 3521.359534] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.359541] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 130, i =3D 127,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.359550] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 130, i =3D 128,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.359608] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 130, i =3D 129,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.359614] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.359626] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 20, b 0, c 0, dBm -87
[ 3521.359722] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.359769] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102384 usecs
[ 3521.359775] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 12 =A0ofdm: fa 0 badp 0
[ 3521.359781] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511920
[ 3521.359787] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
21, b 0, c 0, 20-bcn max 28
[ 3521.359793] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
72, b 95, c 95, 10-bcn max/min 72
[ 3521.359798] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.359803] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3521.359808] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
9
[ 3521.359815] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.359821] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 79
[ 3521.359827] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3521.361233] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 889 value
0x00148000
[ 3521.361239] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.361272] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.361274]
[ 3521.361278] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.361284] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 131, i =3D 130,
MISSED_BEACONS_NOTIFICATION, 0xa2
[ 3521.361291] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.371157] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 890 value
0x00001000
[ 3521.371165] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.371199] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.371201]
[ 3521.371205] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.371211] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 131, i =3D 131
[ 3521.371216] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.385956] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 891 value
0x00048000
[ 3521.385964] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3521.385997] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.385999]
[ 3521.386003] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.386011] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 132, i =3D 131,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.386020] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.395880] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 892 value
0x00001000
[ 3521.395888] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.395922] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.395924]
[ 3521.395928] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.395933] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 132, i =3D 132
[ 3521.395938] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.431456] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 893 value
0x00048000
[ 3521.431464] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3521.431497] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.431499]
[ 3521.431503] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.431511] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 133, i =3D 132,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.431520] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.441383] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 894 value
0x00001000
[ 3521.441390] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.441424] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.441426]
[ 3521.441430] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.441435] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 133, i =3D 133
[ 3521.441441] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.461886] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 895 value
0x00148000
[ 3521.461895] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.461928] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.461930]
[ 3521.461934] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.461942] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 136, i =3D 133,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.461950] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 136, i =3D 134,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.462009] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 136, i =3D 135,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.462014] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.462022] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 20, b 0, c 0, dBm -87
[ 3521.462040] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.462060] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102367 usecs
[ 3521.462067] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 41 =A0ofdm: fa 0 badp 0
[ 3521.462072] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511835
[ 3521.462078] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
19, b 0, c 0, 20-bcn max 28
[ 3521.462084] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
72, b 95, c 95, 10-bcn max/min 72
[ 3521.462088] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.462094] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
8396800 > max FA 5118350
[ 3521.462098] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ...
reducing sensitivity
[ 3521.462103] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3521.462108] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.462114] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3521.462124] iwlwifi 0000:03:00.0: U iwl_enqueue_hcmd Sending
command SENSITIVITY_CMD (#a8), seq: 0x042A, 28 bytes at 42[10]:4
[ 3521.462239] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 896 value
0x00148000
[ 3521.462245] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.462278] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.462280]
[ 3521.462284] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.462289] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 137, i =3D 136,
SENSITIVITY_CMD, 0xa8
[ 3521.462295] iwlwifi 0000:03:00.0: I iwl_rx_dispatch No handler
needed for SENSITIVITY_CMD, 0xa8
[ 3521.462302] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.472177] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 897 value
0x00001000
[ 3521.472185] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.472217] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.472219]
[ 3521.472224] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.472229] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 137, i =3D 137
[ 3521.472235] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.476400] iwlwifi 0000:03:00.0: I rs_get_rate rate scale
calculate new rate for skb
[ 3521.476414] iwlwifi 0000:03:00.0: I iwlagn_mac_tx dev->xmit(70
bytes) at rate 0x5a
[ 3521.476421] iwlwifi 0000:03:00.0: I iwlagn_tx_skb station Id 0
[ 3521.476428] iwlwifi 0000:03:00.0: I iwlagn_tx_cmd_build_hwcrypto
tx_cmd with AES hwcrypto
[ 3521.476438] iwlwifi 0000:03:00.0: I iwl_trans_pcie_tx sequence nr =3D 0X=
cf6
[ 3521.476442] iwlwifi 0000:03:00.0: I iwl_trans_pcie_tx tx_flags =3D 0X500=
019
[ 3521.476447] iwl data: 00000000: 46 00 00 00 19 00 50 00 00 00 00 00
00 00 00 00 =A0F.....P.........
[ 3521.476451] iwl data: 00000010: 00 02 00 00 63 17 a2 17 f0 79 36 f7
ad ea 16 94 =A0....c....y6.....
[ 3521.476455] iwl data: 00000020: 61 39 70 00 00 00 00 00 ff ff ff ff
2c 65 c0 5a =A0a9p.........,e.Z
[ 3521.476459] iwl data: 00000030: 00 3c 0f 00 00 00 00 00
=A0 =A0 =A0 =A0 =A0 =A0 =A0.<......
[ 3521.476463] iwl data: 00000000: 88 41 00 00 00 23 69 be f3 e2 00 1e
64 06 05 96 =A0.A...#i.....d...
[ 3521.476467] iwl data: 00000010: ff ff ff ff ff ff 60 0f 00 00
=A0 =A0 =A0 =A0 =A0 =A0 =A0......`...
[ 3521.565829] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 898 value
0x00148000
[ 3521.565838] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.565872] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.565874]
[ 3521.565879] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.565887] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 139, i =3D 137,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.565896] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 139, i =3D 138,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.565986] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.568935] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 899 value
0x00148000
[ 3521.568943] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.568978] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.568980]
[ 3521.568984] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.568992] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 140, i =3D 139,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.568998] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.569009] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 23, b 0, c 0, dBm -84
[ 3521.569027] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.569049] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 103879 usecs
[ 3521.569056] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 57 =A0ofdm: fa 0 badp 3
[ 3521.569063] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm min FA
519395 < norm FA 614400 < max FA 5193950 OK
[ 3521.569069] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
21, b 0, c 0, 20-bcn max 28
[ 3521.569075] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
61, b 88, c 88, 10-bcn max/min 72
[ 3521.569080] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.569086] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
11673600 > max FA 5193950
[ 3521.569090] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ...
reducing sensitivity
[ 3521.569095] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3521.569101] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.569108] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3521.569113] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3521.571454] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 900 value
0x00048000
[ 3521.571461] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3521.571494] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.571496]
[ 3521.571500] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.571506] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 141, i =3D 140,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.571513] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.581377] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 901 value
0x00001000
[ 3521.581384] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.581417] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.581419]
[ 3521.581424] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.581429] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 141, i =3D 141
[ 3521.581434] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.613891] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 902 value
0x00048000
[ 3521.613900] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3521.613934] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.613935]
[ 3521.613940] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.613947] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 142, i =3D 141,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.613956] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.623817] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 903 value
0x00001000
[ 3521.623825] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.623858] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.623860]
[ 3521.623864] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.623869] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 142, i =3D 142
[ 3521.623875] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.657503] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 904 value
0x00048000
[ 3521.657512] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3521.657544] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.657547]
[ 3521.657551] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.657558] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 143, i =3D 142,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.657567] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.666683] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 905 value
0x00148000
[ 3521.666691] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.666723] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.666725]
[ 3521.666729] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.666736] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 146, i =3D 143,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.666744] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 146, i =3D 144,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.666800] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 146, i =3D 145,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.666806] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.666813] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 18, b 0, c 0, dBm -89
[ 3521.666854] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 100820 usecs
[ 3521.666861] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 23 =A0ofdm: fa 0 badp 0
[ 3521.666867] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 504100
[ 3521.666870] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.666877] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
15, b 0, c 0, 20-bcn max 28
[ 3521.666883] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
61, b 85, c 85, 10-bcn max/min 72
[ 3521.666888] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.666893] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3521.666897] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... increasing m=
argin
[ 3521.666902] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3521.666908] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.666914] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3521.666919] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3521.676716] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 906 value
0x00001000
[ 3521.676724] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.676758] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.676760]
[ 3521.676764] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.676769] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 146, i =3D 146
[ 3521.676775] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.702422] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 907 value
0x00048000
[ 3521.702430] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3521.702462] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.702464]
[ 3521.702468] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.702475] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 148, i =3D 146,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.702483] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 148, i =3D 147,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.702490] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.712348] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 908 value
0x00001000
[ 3521.712355] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.712389] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.712391]
[ 3521.712396] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.712401] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 148, i =3D 148
[ 3521.712407] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.769082] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 909 value
0x00148000
[ 3521.769091] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.769124] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.769126]
[ 3521.769130] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.769137] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 151, i =3D 148,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.769146] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 151, i =3D 149,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.769207] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 151, i =3D 150,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.769213] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.769225] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 20, b 0, c 0, dBm -87
[ 3521.769242] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.769249] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102372 usecs
[ 3521.769257] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 28 =A0ofdm: fa 0 badp 0
[ 3521.769263] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511860
[ 3521.769268] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
19, b 0, c 0, 20-bcn max 28
[ 3521.769274] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
62, b 86, c 86, 10-bcn max/min 72
[ 3521.769280] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.769285] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
5734400 > max FA 5118600
[ 3521.769290] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ...
reducing sensitivity
[ 3521.769295] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3521.769301] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.769307] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3521.769313] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3521.779114] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 910 value
0x00001000
[ 3521.779123] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.779157] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.779159]
[ 3521.779163] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.779169] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 151, i =3D 151
[ 3521.779174] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.835532] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 911 value
0x00048000
[ 3521.835541] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3521.835573] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.835575]
[ 3521.835579] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.835587] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 152, i =3D 151,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.835596] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.845456] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 912 value
0x00001000
[ 3521.845464] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.845497] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.845499]
[ 3521.845503] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.845508] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 152, i =3D 152
[ 3521.845513] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.871511] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 913 value
0x00148000
[ 3521.871519] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.871551] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.871553]
[ 3521.871558] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.871565] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 155, i =3D 152,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.871574] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 155, i =3D 153,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.871624] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 155, i =3D 154,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.871630] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.871637] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 22, b 0, c 0, dBm -85
[ 3521.871682] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.871738] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102384 usecs
[ 3521.871745] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 39 =A0ofdm: fa 0 badp 2
[ 3521.871751] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
409600 < min FA 511920
[ 3521.871757] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
20, b 0, c 0, 20-bcn max 28
[ 3521.871762] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
72, b 95, c 95, 10-bcn max/min 72
[ 3521.871768] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.871773] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
7987200 > max FA 5119200
[ 3521.871778] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ...
reducing sensitivity
[ 3521.871783] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3521.871788] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.871794] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3521.871799] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3521.873235] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 914 value
0x00148000
[ 3521.873243] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.873276] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.873278]
[ 3521.873282] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.873289] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 156, i =3D 155,
MISSED_BEACONS_NOTIFICATION, 0xa2
[ 3521.873296] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.882507] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 915 value
0x00048000
[ 3521.882514] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3521.882547] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.882548]
[ 3521.882552] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.882559] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 157, i =3D 156,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.882565] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.892429] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 916 value
0x00001000
[ 3521.892438] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.892471] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.892474]
[ 3521.892478] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.892483] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 157, i =3D 157
[ 3521.892489] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.973932] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 917 value
0x00148000
[ 3521.973940] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 918 value
0x00148000
[ 3521.973945] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3521.973977] iwlwifi 0000:03:00.0: I iwl_isr_ict Ignore interrupt, inta =
=3D=3D 0
[ 3521.974010] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3521.974012]
[ 3521.974016] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.974023] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 160, i =3D 157,
REPLY_RX_PHY_CMD, 0xc0
[ 3521.974032] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 160, i =3D 158,
REPLY_RX_MPDU_CMD, 0xc1
[ 3521.974086] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 160, i =3D 159,
STATISTICS_NOTIFICATION, 0x9d
[ 3521.974092] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3521.974104] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 19, b 0, c 0, dBm -88
[ 3521.974115] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3521.974149] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102376 usecs
[ 3521.974157] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 63 =A0ofdm: fa 0 badp 1
[ 3521.974163] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
204800 < min FA 511880
[ 3521.974169] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
17, b 0, c 0, 20-bcn max 28
[ 3521.974175] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
71, b 95, c 95, 10-bcn max/min 72
[ 3521.974180] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3521.974186] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
12902400 > max FA 5118800
[ 3521.974191] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ...
reducing sensitivity
[ 3521.974196] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3521.974202] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3521.974208] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3521.974213] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3521.983986] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 919 value
0x00001000
[ 3521.983994] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3521.984026] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3521.984028]
[ 3521.984033] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3521.984038] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 160, i =3D 160
[ 3521.984043] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.018147] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 920 value
0x00048000
[ 3522.018154] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3522.018188] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.018190]
[ 3522.018194] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.018202] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 161, i =3D 160,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.018211] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.025399] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 921 value
0x00048000
[ 3522.025407] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3522.025440] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.025442]
[ 3522.025447] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.025454] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 162, i =3D 161,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.025483] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.035350] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 922 value
0x00001000
[ 3522.035358] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3522.035391] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3522.035393]
[ 3522.035397] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.035403] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 162, i =3D 162
[ 3522.035408] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.060903] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 923 value
0x00048000
[ 3522.060912] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3522.060946] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.060948]
[ 3522.060952] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.060960] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 164, i =3D 162,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.060969] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 164, i =3D 163,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.060976] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.070840] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 924 value
0x00001000
[ 3522.070848] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3522.070880] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3522.070882]
[ 3522.070887] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.070892] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 164, i =3D 164
[ 3522.070898] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.076406] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 925 value
0x00148000
[ 3522.076413] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3522.076446] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.076448]
[ 3522.076452] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.076459] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 167, i =3D 164,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.076467] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 167, i =3D 165,
REPLY_RX_MPDU_CMD, 0xc1
[ 3522.076518] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 167, i =3D 166,
STATISTICS_NOTIFICATION, 0x9d
[ 3522.076524] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3522.076531] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 22, b 0, c 0, dBm -85
[ 3522.076543] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.076886] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102458 usecs
[ 3522.076894] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 18 =A0ofdm: fa 0 badp 1
[ 3522.076899] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
204800 < min FA 512290
[ 3522.076906] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
23, b 0, c 0, 20-bcn max 28
[ 3522.076911] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
62, b 86, c 86, 10-bcn max/min 72
[ 3522.076917] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3522.076922] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3522.076927] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... increasing m=
argin
[ 3522.076931] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3522.076937] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3522.076943] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3522.076948] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3522.086416] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 926 value
0x00001000
[ 3522.086424] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3522.086457] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3522.086459]
[ 3522.086463] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.086469] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 167, i =3D 167
[ 3522.086474] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.178698] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 927 value
0x00148000
[ 3522.178706] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 928 value
0x00148000
[ 3522.178711] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3522.178743] iwlwifi 0000:03:00.0: I iwl_isr_ict Ignore interrupt, inta =
=3D=3D 0
[ 3522.178776] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.178778]
[ 3522.178782] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.178789] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 170, i =3D 167,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.178797] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 170, i =3D 168,
REPLY_RX_MPDU_CMD, 0xc1
[ 3522.178852] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 170, i =3D 169,
STATISTICS_NOTIFICATION, 0x9d
[ 3522.178859] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3522.178870] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 17, b 0, c 0, dBm -90
[ 3522.178904] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102287 usecs
[ 3522.178911] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 4 =A0ofdm: fa 0 badp 0
[ 3522.178917] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 511435
[ 3522.178923] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
14, b 0, c 0, 20-bcn max 28
[ 3522.178926] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.178933] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
62, b 86, c 86, 10-bcn max/min 72
[ 3522.178938] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 0
[ 3522.178944] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck =A0FA in safe zo=
ne
[ 3522.178948] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3522.178954] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3522.178960] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3522.178966] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3522.188769] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 929 value
0x00001000
[ 3522.188777] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3522.188810] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3522.188812]
[ 3522.188816] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.188821] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 170, i =3D 170
[ 3522.188826] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.196216] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 930 value
0x00048000
[ 3522.196224] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3522.196258] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.196260]
[ 3522.196264] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.196271] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 171, i =3D 170,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.196280] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.206140] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 931 value
0x00001000
[ 3522.206148] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3522.206182] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3522.206184]
[ 3522.206188] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.206193] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 171, i =3D 171
[ 3522.206199] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.257778] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 932 value
0x00048000
[ 3522.257786] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00048000
[ 3522.257820] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.257822]
[ 3522.257826] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.257834] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 172, i =3D 171,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.257843] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.267720] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 933 value
0x00001000
[ 3522.267728] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3522.267761] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3522.267763]
[ 3522.267767] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.267772] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 172, i =3D 172
[ 3522.267778] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.281081] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 934 value
0x00148000
[ 3522.281089] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3522.281123] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.281124]
[ 3522.281129] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.281136] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 175, i =3D 172,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.281144] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 175, i =3D 173,
REPLY_RX_MPDU_CMD, 0xc1
[ 3522.281198] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 175, i =3D 174,
STATISTICS_NOTIFICATION, 0x9d
[ 3522.281204] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3522.281211] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 20, b 0, c 0, dBm -87
[ 3522.281229] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.281237] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102378 usecs
[ 3522.281244] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 0 =A0ofdm: fa 0 badp 1
[ 3522.281251] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
204800 < min FA 511890
[ 3522.281257] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
21, b 0, c 0, 20-bcn max 28
[ 3522.281263] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
71, b 94, c 94, 10-bcn max/min 72
[ 3522.281268] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 1
[ 3522.281273] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA 0 <
min FA 511890, silence diff 0
[ 3522.281278] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3522.281283] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3522.281289] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3522.281295] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3522.281300] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3522.291089] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 935 value
0x00001000
[ 3522.291098] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3522.291131] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3522.291133]
[ 3522.291137] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.291142] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 175, i =3D 175
[ 3522.291148] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.383491] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 936 value
0x00148000
[ 3522.383500] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3522.383534] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.383536]
[ 3522.383540] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.383548] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 178, i =3D 175,
REPLY_RX_PHY_CMD, 0xc0
[ 3522.383556] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 178, i =3D 176,
REPLY_RX_MPDU_CMD, 0xc1
[ 3522.383617] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 178, i =3D 177,
STATISTICS_NOTIFICATION, 0x9d
[ 3522.383623] iwlwifi 0000:03:00.0: I iwlagn_rx_statistics Statistics
notification received (480 bytes).
[ 3522.383635] iwlwifi 0000:03:00.0: I iwlagn_rx_calc_noise inband
silence a 21, b 0, c 0, dBm -86
[ 3522.383664] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
rx_enable_time =3D 102401 usecs
[ 3522.383672] iwlwifi 0000:03:00.0: U iwl_sensitivity_calibration
cck: fa 0 badp 2 =A0ofdm: fa 0 badp 0
[ 3522.383678] iwlwifi 0000:03:00.0: U iwl_sens_auto_corr_ofdm norm FA
0 < min FA 512005
[ 3522.383684] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck silence a
17, b 0, c 0, 20-bcn max 28
[ 3522.383689] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.383693] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck rx energy a
72, b 94, c 94, 10-bcn max/min 72
[ 3522.383698] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck consecutive
bcns with few false alarms =3D 2
[ 3522.383702] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck norm FA
409600 < min FA 512005, silence diff 0
[ 3522.383707] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck ... but not
changing sensitivity
[ 3522.383711] iwlwifi 0000:03:00.0: U iwl_sens_energy_cck new nrg_th_cck 7=
8
[ 3522.383716] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl ofdm: ac 90 mrc 170 x1 120 mrc_x1
240 thresh 95
[ 3522.383722] iwlwifi 0000:03:00.0: U
iwl_prepare_legacy_sensitivity_tbl cck: ac 200 mrc 400 thresh 78
[ 3522.383727] iwlwifi 0000:03:00.0: U iwl_sensitivity_write No change
in SENSITIVITY_CMD
[ 3522.385228] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 937 value
0x00148000
[ 3522.385235] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x80000000, enabled 0xba00008b ict 0x00148000
[ 3522.385268] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x80000000, enabled 0x00000000
[ 3522.385270]
[ 3522.385274] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.385281] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 179, i =3D 178,
MISSED_BEACONS_NOTIFICATION, 0xa2
[ 3522.385288] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts
[ 3522.395153] iwlwifi 0000:03:00.0: I iwl_isr_ict ICT index 938 value
0x00001000
[ 3522.395161] iwlwifi 0000:03:00.0: I iwl_isr_ict ISR inta
0x10000000, enabled 0xba00008b ict 0x00001000
[ 3522.395194] iwlwifi 0000:03:00.0: I iwl_irq_tasklet inta
0x10000000, enabled 0x00000000
[ 3522.395196]
[ 3522.395200] iwlwifi 0000:03:00.0: I iwl_irq_tasklet Rx interrupt
[ 3522.395206] iwlwifi 0000:03:00.0: I iwl_rx_handle r =3D 179, i =3D 179
[ 3522.395211] iwlwifi 0000:03:00.0: I iwl_enable_interrupts Enabling inter=
rupts

--_002_5D69FF551B764E40A8245E579F3F73E60210736FORSMSX102amrcor_
Content-Type: application/octet-stream; name="tid.patch"
Content-Description: tid.patch
Content-Disposition: attachment; filename="tid.patch"; size=1998;
	creation-date="Mon, 30 Jan 2012 15:56:39 GMT";
	modification-date="Mon, 30 Jan 2012 15:56:39 GMT"
Content-Transfer-Encoding: base64

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLWFnbi10eC5jIGIv
ZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMKaW5kZXggZDlkNzU4ZS4u
MWI3MDA0OCAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWdu
LXR4LmMKKysrIGIvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9pd2wtYWduLXR4LmMKQEAg
LTk1LDYgKzk1LDcgQEAgc3RhdGljIHZvaWQgaXdsYWduX3R4X2NtZF9idWlsZF9iYXNpYyhzdHJ1
Y3QgaXdsX3ByaXYgKnByaXYsCiAJCQl0eF9mbGFncyB8PSBUWF9DTURfRkxHX1NFUV9DVExfTVNL
OwogCQllbHNlCiAJCQl0eF9mbGFncyAmPSB+VFhfQ01EX0ZMR19TRVFfQ1RMX01TSzsKKwkJdHhf
Y21kLT50aWRfdHNwZWMgPSBJV0xfTUFYX1RJRF9DT1VOVDsKIAl9CiAKIAlpd2xhZ25fdHhfY21k
X3Byb3RlY3Rpb24ocHJpdiwgaW5mbywgZmMsICZ0eF9mbGFncyk7CkBAIC04MDgsNiArODA5LDgg
QEAgc3RhdGljIHZvaWQgaXdsX3J4X3JlcGx5X3R4X2FnZyhzdHJ1Y3QgaXdsX3ByaXYgKnByaXYs
CiAJdTMyIHN0YXR1cyA9IGxlMTZfdG9fY3B1KHR4X3Jlc3AtPnN0YXR1cy5zdGF0dXMpOwogCWlu
dCBpOwogCisgICAgICAgIFdBUk5fT04odGlkID09IElXTF9NQVhfVElEX0NPVU5UKTsKKwogCWlm
IChhZ2ctPndhaXRfZm9yX2JhKQogCQlJV0xfREVCVUdfVFhfUkVQTFkocHJpdiwKIAkJCSJnb3Qg
dHggcmVzcG9uc2Ugdy9vIGJsb2NrLWFja1xuIik7CkBAIC0xMDM1LDEwICsxMDM4LDEyIEBAIGlu
dCBpd2xhZ25fcnhfcmVwbHlfdHgoc3RydWN0IGl3bF9wcml2ICpwcml2LCBzdHJ1Y3QgaXdsX3J4
X21lbV9idWZmZXIgKnJ4YiwKIAkJfQogCiAJCV9fc2tiX3F1ZXVlX2hlYWRfaW5pdCgmc2ticyk7
Ci0JCXByaXYtPnRpZF9kYXRhW3N0YV9pZF1bdGlkXS5uZXh0X3JlY2xhaW1lZCA9IG5leHRfcmVj
bGFpbWVkOwogCi0JCUlXTF9ERUJVR19UWF9SRVBMWShwcml2LCAiTmV4dCByZWNsYWltZWQgcGFj
a2V0OiVkIiwKLQkJCQkJICBuZXh0X3JlY2xhaW1lZCk7CisJCWlmICh0aWQgIT0gSVdMX01BWF9U
SURfQ09VTlQpIHsKKwkJCXByaXYtPnRpZF9kYXRhW3N0YV9pZF1bdGlkXS5uZXh0X3JlY2xhaW1l
ZCA9IG5leHRfcmVjbGFpbWVkOworCQkJSVdMX0RFQlVHX1RYX1JFUExZKHByaXYsICJOZXh0IHJl
Y2xhaW1lZCBwYWNrZXQ6JWQiLAorCQkJCQkJICBuZXh0X3JlY2xhaW1lZCk7CisJCX0KIAogCQkv
KndlIGNhbiBmcmVlIHVudGlsIHNzbiAlIHEubl9iZCBub3QgaW5jbHVzaXZlICovCiAJCVdBUk5f
T04oaXdsX3RyYW5zX3JlY2xhaW0odHJhbnMocHJpdiksIHN0YV9pZCwgdGlkLCB0eHFfaWQsCmRp
ZmYgLS1naXQgYS9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy1wY2llLmMg
Yi9kcml2ZXJzL25ldC93aXJlbGVzcy9pd2x3aWZpL2l3bC10cmFucy1wY2llLmMKaW5kZXggYWE4
Nzk5NC4uZmExYjM2OSAxMDA2NDQKLS0tIGEvZHJpdmVycy9uZXQvd2lyZWxlc3MvaXdsd2lmaS9p
d2wtdHJhbnMtcGNpZS5jCisrKyBiL2RyaXZlcnMvbmV0L3dpcmVsZXNzL2l3bHdpZmkvaXdsLXRy
YW5zLXBjaWUuYwpAQCAtMTU1MSw3ICsxNTUxLDcgQEAgc3RhdGljIGludCBpd2xfdHJhbnNfcGNp
ZV9yZWNsYWltKHN0cnVjdCBpd2xfdHJhbnMgKnRyYW5zLCBpbnQgc3RhX2lkLCBpbnQgdGlkLAog
CiAJdHhxLT50aW1lX3N0YW1wID0gamlmZmllczsKIAotCWlmICh1bmxpa2VseSh0eHFfaWQgPj0g
SVdMQUdOX0ZJUlNUX0FNUERVX1FVRVVFICYmCisJaWYgKHVubGlrZWx5KHRpZCAhPSBJV0xfTUFY
X1RJRF9DT1VOVCAmJiB0eHFfaWQgPj0gSVdMQUdOX0ZJUlNUX0FNUERVX1FVRVVFICYmCiAJCSAg
ICAgdHhxX2lkICE9IHRyYW5zX3BjaWUtPmFnZ190eHFbc3RhX2lkXVt0aWRdKSkgewogCQkvKgog
CQkgKiBGSVhNRTogdGhpcyBpcyBhIHVDb2RlIGJ1ZyB3aGljaCBuZWVkIHRvIGJlIGFkZHJlc3Nl
ZCwK

--_002_5D69FF551B764E40A8245E579F3F73E60210736FORSMSX102amrcor_--
