Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751221Ab2DJEMM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Apr 2012 00:12:12 -0400
Received: from mga11.intel.com ([192.55.52.93]:40601 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750847Ab2DJEMK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Apr 2012 00:12:10 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="139737751"
Subject: Re: 3.4.0-rc2 -- iwlwifi 0000:03:00.0: Hardware error detected.
 Restarting.
From: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>
In-Reply-To: <CAHFgRy_S-FMwHKdzp2=kUDNwXBqBvkaetkkaZzkcsswJd+O36A@mail.gmail.com>
References: <CAHFgRy_S-FMwHKdzp2=kUDNwXBqBvkaetkkaZzkcsswJd+O36A@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 09 Apr 2012 21:08:52 -0700
Message-ID: <1334030932.27767.78.camel@wwguy-huron>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Lane,

so looks like you are using 1000 device, are you seeing the similar
issue in kernel 3.4 or 3.4-rc1?

I saw the firmware being reload and reconnect, is the device working
after reconnect?

I could not make a lot of sense from the log you sent, could it be
possible if you enable the debug log which can help us collect more
information?

#modprobe iwlwifi debug=0x43fff


Thanks a lot for reporting
Wey

On Mon, 2012-04-09 at 23:14 -0400, Miles Lane wrote:
> Not sure if this is information you need.  This is the first time I
> have seen this message.
> 
> wlan0: authenticate with 00:23:69:be:f3:e2
> wlan0: direct probe to 00:23:69:be:f3:e2 (try 1/3)
> wlan0: send auth to 00:23:69:be:f3:e2 (try 2/3)
> wlan0: authenticated
> wlan0: associate with 00:23:69:be:f3:e2 (try 1/3)
> wlan0: RX AssocResp from 00:23:69:be:f3:e2 (capab=0x411 status=0 aid=5)
> wlan0: associated
> wlan0: authenticate with 00:1b:2f:0e:ed:ba
> wlan0: direct probe to 00:1b:2f:0e:ed:ba (try 1/3)
> wlan0: send auth to 00:1b:2f:0e:ed:ba (try 2/3)
> wlan0: authenticated
> wlan0: associate with 00:1b:2f:0e:ed:ba (try 1/3)
> wlan0: RX AssocResp from 00:1b:2f:0e:ed:ba (capab=0x431 status=0 aid=2)
> wlan0: associated
> iwlwifi 0000:03:00.0: Hardware error detected.  Restarting.
> iwlwifi 0000:03:00.0: Loaded firmware version: 39.31.5.1 build 35138
> iwlwifi 0000:03:00.0: 0x00000000 | OK
> iwlwifi 0000:03:00.0: 0x00000000 | uPc
> iwlwifi 0000:03:00.0: 0x00000000 | branchlink1
> iwlwifi 0000:03:00.0: 0x00000000 | branchlink2
> iwlwifi 0000:03:00.0: 0x00000000 | interruptlink1
> iwlwifi 0000:03:00.0: 0x00000000 | interruptlink2
> iwlwifi 0000:03:00.0: 0x00000000 | data1
> iwlwifi 0000:03:00.0: 0x00000000 | data2
> iwlwifi 0000:03:00.0: 0x00000000 | line
> iwlwifi 0000:03:00.0: 0x00000000 | beacon time
> iwlwifi 0000:03:00.0: 0x00000000 | tsf low
> iwlwifi 0000:03:00.0: 0x00000000 | tsf hi
> iwlwifi 0000:03:00.0: 0x00000000 | time gp1
> iwlwifi 0000:03:00.0: 0x00000000 | time gp2
> iwlwifi 0000:03:00.0: 0x00000000 | time gp3
> iwlwifi 0000:03:00.0: 0x00000000 | uCode version
> iwlwifi 0000:03:00.0: 0x00000000 | hw version
> iwlwifi 0000:03:00.0: 0x00000000 | board version
> iwlwifi 0000:03:00.0: 0x00000000 | hcmd
> iwlwifi 0000:03:00.0: 0x00000000 | isr0
> iwlwifi 0000:03:00.0: 0x00000000 | isr1
> iwlwifi 0000:03:00.0: 0x00000000 | isr2
> iwlwifi 0000:03:00.0: 0x00000000 | isr3
> iwlwifi 0000:03:00.0: 0x00000000 | isr4
> iwlwifi 0000:03:00.0: 0x00000000 | isr_pref
> iwlwifi 0000:03:00.0: 0x00000000 | wait_event
> iwlwifi 0000:03:00.0: 0x00000000 | l2p_control
> iwlwifi 0000:03:00.0: 0x00000000 | l2p_duration
> iwlwifi 0000:03:00.0: 0x00000000 | l2p_mhvalid
> iwlwifi 0000:03:00.0: 0x00000000 | l2p_addr_match
> iwlwifi 0000:03:00.0: 0x00000000 | lmpm_pmg_sel
> iwlwifi 0000:03:00.0: 0x00000000 | timestamp
> iwlwifi 0000:03:00.0: 0x00000000 | flow_handler
> iwlwifi 0000:03:00.0: CSR values:
> iwlwifi 0000:03:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
> iwlwifi 0000:03:00.0:        CSR_HW_IF_CONFIG_REG: 0X00c80300
> iwlwifi 0000:03:00.0:          CSR_INT_COALESCING: 0X00000040
> iwlwifi 0000:03:00.0:                     CSR_INT: 0X20000000
> iwlwifi 0000:03:00.0:                CSR_INT_MASK: 0X00000000
> iwlwifi 0000:03:00.0:           CSR_FH_INT_STATUS: 0X00000000
> iwlwifi 0000:03:00.0:                 CSR_GPIO_IN: 0X00000000
> iwlwifi 0000:03:00.0:                   CSR_RESET: 0X00000008
> iwlwifi 0000:03:00.0:                CSR_GP_CNTRL: 0X080003c5
> iwlwifi 0000:03:00.0:                  CSR_HW_REV: 0X0000006c
> iwlwifi 0000:03:00.0:              CSR_EEPROM_REG: 0X00001885
> iwlwifi 0000:03:00.0:               CSR_EEPROM_GP: 0X90000001
> iwlwifi 0000:03:00.0:              CSR_OTP_GP_REG: 0X00010001
> iwlwifi 0000:03:00.0:                 CSR_GIO_REG: 0X00080042
> iwlwifi 0000:03:00.0:            CSR_GP_UCODE_REG: 0X0000c45f
> iwlwifi 0000:03:00.0:           CSR_GP_DRIVER_REG: 0X00000000
> iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
> iwlwifi 0000:03:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
> iwlwifi 0000:03:00.0:                 CSR_LED_REG: 0X00000058
> iwlwifi 0000:03:00.0:        CSR_DRAM_INT_TBL_REG: 0X88129268
> iwlwifi 0000:03:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
> iwlwifi 0000:03:00.0:             CSR_ANA_PLL_CFG: 0X00880300
> iwlwifi 0000:03:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
> iwlwifi 0000:03:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
> iwlwifi 0000:03:00.0: FH register values:
> iwlwifi 0000:03:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X129cd100
> iwlwifi 0000:03:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X01326db0
> iwlwifi 0000:03:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000020
> iwlwifi 0000:03:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X80819104
> iwlwifi 0000:03:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
> iwlwifi 0000:03:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X03030000
> iwlwifi 0000:03:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
> iwlwifi 0000:03:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
> iwlwifi 0000:03:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
> iwlwifi 0000:03:00.0: Start IWL Event Log Dump: display last 20 entries
> iwlwifi 0000:03:00.0: EVT_LOGT:1386158447:0x000001d9:0601
> iwlwifi 0000:03:00.0: EVT_LOGT:1386158448:0x00000149:0636
> iwlwifi 0000:03:00.0: EVT_LOGT:1386158550:0x0000010f:0106
> iwlwifi 0000:03:00.0: EVT_LOGT:1386158551:0x00000000:0301
> iwlwifi 0000:03:00.0: EVT_LOGT:1386158933:0x00000080:0313
> iwlwifi 0000:03:00.0: EVT_LOGT:1386158936:0x0000057b:0501
> iwlwifi 0000:03:00.0: EVT_LOGT:1386159972:0x000002c1:0501
> iwlwifi 0000:03:00.0: EVT_LOGT:1386159978:0x00000000:0504
> iwlwifi 0000:03:00.0: EVT_LOGT:1386159980:0x00000000:0504
> iwlwifi 0000:03:00.0: EVT_LOGT:1386159980:0x00000057:0601
> iwlwifi 0000:03:00.0: EVT_LOGT:1386159981:0x52818a62:0600
> iwlwifi 0000:03:00.0: EVT_LOGT:1386159981:0x0000007d:0601
> iwlwifi 0000:03:00.0: EVT_LOGT:1386159982:0x52818a62:0600
> iwlwifi 0000:03:00.0: EVT_LOGT:1386159982:0x00000000:0600
> iwlwifi 0000:03:00.0: EVT_LOGT:1386159987:0x00c00007:0310
> iwlwifi 0000:03:00.0: EVT_LOGT:1386160000:0x000000d2:0601
> iwlwifi 0000:03:00.0: EVT_LOGT:1386160008:0x0000014b:0635
> iwlwifi 0000:03:00.0: EVT_LOGT:1386160011:0x000000f6:0601
> iwlwifi 0000:03:00.0: EVT_LOGT:1386160020:0x0000003a:1055
> iwlwifi 0000:03:00.0: EVT_LOGT:1386160022:0x52818a39:1073
> ieee80211 phy0: Hardware restart was requested
> iwlwifi 0000:03:00.0: L1 Enabled; Disabling L0S
> wlan0: authenticate with 00:23:69:be:f3:e2
> wlan0: direct probe to 00:23:69:be:f3:e2 (try 1/3)
> wlan0: send auth to 00:23:69:be:f3:e2 (try 2/3)
> wlan0: authenticated
> wlan0: associate with 00:23:69:be:f3:e2 (try 1/3)
> wlan0: RX AssocResp from 00:23:69:be:f3:e2 (capab=0x411 status=0 aid=5)
> wlan0: associated


