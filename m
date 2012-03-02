Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758955Ab2CBRAS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Mar 2012 12:00:18 -0500
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:61664 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755932Ab2CBRAQ convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Mar 2012 12:00:16 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of bhelgaas@google.com designates 10.152.115.69 as permitted sender) smtp.mail=bhelgaas@google.com; dkim=pass header.i=bhelgaas@google.com
MIME-Version: 1.0
In-Reply-To: <1330698641.12612.34.camel@wwguy-huron>
References: <20120301143922.GA31369@redhat.com> <1330698641.12612.34.camel@wwguy-huron>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Fri, 2 Mar 2012 09:59:54 -0700
Message-ID: <CAErSpo7d2CekQgmMNQeSDdiDOE82aVG1Z+OMw30szySQQcypUQ@mail.gmail.com>
Subject: Re: [Ilw] firmware error.
To: "Guy, Wey-Yi" <wey-yi.w.guy@intel.com>
Cc: Dave Jones <davej@redhat.com>, linux-kernel@vger.kernel.org,
        ilw@linux.intel.com, linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 2, 2012 at 7:30 AM, Guy, Wey-Yi <wey-yi.w.guy@intel.com> wrote:
> Hi dave,
>
> could you please file a bug in http://bugzilla.intellinuxwireless.org/
> so we can keep track and assign someone work with you.

I've sent many emails just like this one ("please file a bug here"),
but after I received such an email when trying to report a Comcast web
page deficiency, I realize that this approach isn't as
customer-friendly as it could be.  The bugzilla is for *your*
convenience, not Dave's.  We want to make it as easy as possible for
users to report issues, and that means doing as much of the work as
possible ourselves rather than pushing it to the user.

In the future, my approach will be to respond along the lines of
"Thank you very much for the bug report.  I opened bugzilla <URL> to
help us keep track of this and attached the information you provided.
Someone will respond in this email thread with updates."

Bjorn

> On Thu, 2012-03-01 at 09:39 -0500, Dave Jones wrote:
>> Still seeing this occasionally in v3.3-rc5-101-g88ebdda
>>
>> iwlwifi 0000:04:00.0: Received BA when not expected
>> iwlwifi 0000:04:00.0: Microcode SW error detected.  Restarting 0x2000000.
>> iwlwifi 0000:04:00.0: Loaded firmware version: 8.83.5.1 build 33692
>> iwlwifi 0000:04:00.0: Start IWL Error Log Dump:
>> iwlwifi 0000:04:00.0: Status: 0x000412E4, count: 5
>> iwlwifi 0000:04:00.0: 0x0000001C | ADVANCED_SYSASSERT
>> iwlwifi 0000:04:00.0: 0x000006E4 | uPc
>> iwlwifi 0000:04:00.0: 0x000005AA | branchlink1
>> iwlwifi 0000:04:00.0: 0x00000820 | branchlink2
>> iwlwifi 0000:04:00.0: 0x00000916 | interruptlink1
>> iwlwifi 0000:04:00.0: 0x0000E52E | interruptlink2
>> iwlwifi 0000:04:00.0: 0x00000002 | data1
>> iwlwifi 0000:04:00.0: 0x02630000 | data2
>> iwlwifi 0000:04:00.0: 0x00000236 | line
>> iwlwifi 0000:04:00.0: 0x00C04D1D | beacon time
>> iwlwifi 0000:04:00.0: 0xFDF602E3 | tsf low
>> iwlwifi 0000:04:00.0: 0x000000DD | tsf hi
>> iwlwifi 0000:04:00.0: 0x00000000 | time gp1
>> iwlwifi 0000:04:00.0: 0x57F562C0 | time gp2
>> iwlwifi 0000:04:00.0: 0x00000000 | time gp3
>> iwlwifi 0000:04:00.0: 0x00010853 | uCode version
>> iwlwifi 0000:04:00.0: 0x00000024 | hw version
>> iwlwifi 0000:04:00.0: 0x00480302 | board version
>> iwlwifi 0000:04:00.0: 0x0B59001C | hcmd
>> iwlwifi 0000:04:00.0: 0x2F873802 | isr0
>> iwlwifi 0000:04:00.0: 0x014BF800 | isr1
>> iwlwifi 0000:04:00.0: 0x0000011A | isr2
>> iwlwifi 0000:04:00.0: 0x1443FCC3 | isr3
>> iwlwifi 0000:04:00.0: 0x00804110 | isr4
>> iwlwifi 0000:04:00.0: 0x00000236 | isr_pref
>> iwlwifi 0000:04:00.0: 0x000000D4 | wait_event
>> iwlwifi 0000:04:00.0: 0x00000004 | l2p_control
>> iwlwifi 0000:04:00.0: 0x00000007 | l2p_duration
>> iwlwifi 0000:04:00.0: 0x00101042 | l2p_mhvalid
>> iwlwifi 0000:04:00.0: 0x00000015 | l2p_addr_match
>> iwlwifi 0000:04:00.0: 0x02121704 | lmpm_pmg_sel
>> iwlwifi 0000:04:00.0: 0x14B498A0 | timestamp
>> iwlwifi 0000:04:00.0: 0x00000100 | flow_handler
>> iwlwifi 0000:04:00.0: CSR values:
>> iwlwifi 0000:04:00.0: (2nd byte of CSR_INT_COALESCING is CSR_INT_PERIODIC_REG)
>> iwlwifi 0000:04:00.0:        CSR_HW_IF_CONFIG_REG: 0X00480302
>> iwlwifi 0000:04:00.0:          CSR_INT_COALESCING: 0X00000040
>> iwlwifi 0000:04:00.0:                     CSR_INT: 0X00000000
>> iwlwifi 0000:04:00.0:                CSR_INT_MASK: 0X00000000
>> iwlwifi 0000:04:00.0:           CSR_FH_INT_STATUS: 0X00000000
>> iwlwifi 0000:04:00.0:                 CSR_GPIO_IN: 0X00000000
>> iwlwifi 0000:04:00.0:                   CSR_RESET: 0X00000000
>> iwlwifi 0000:04:00.0:                CSR_GP_CNTRL: 0X080403c5
>> iwlwifi 0000:04:00.0:                  CSR_HW_REV: 0X00000024
>> iwlwifi 0000:04:00.0:              CSR_EEPROM_REG: 0X00000000
>> iwlwifi 0000:04:00.0:               CSR_EEPROM_GP: 0X90000004
>> iwlwifi 0000:04:00.0:              CSR_OTP_GP_REG: 0X00060000
>> iwlwifi 0000:04:00.0:                 CSR_GIO_REG: 0X00080042
>> iwlwifi 0000:04:00.0:            CSR_GP_UCODE_REG: 0X00003001
>> iwlwifi 0000:04:00.0:           CSR_GP_DRIVER_REG: 0X00000000
>> iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP1: 0X00000000
>> iwlwifi 0000:04:00.0:           CSR_UCODE_DRV_GP2: 0X00000000
>> iwlwifi 0000:04:00.0:                 CSR_LED_REG: 0X00000058
>> iwlwifi 0000:04:00.0:        CSR_DRAM_INT_TBL_REG: 0X8811137b
>> iwlwifi 0000:04:00.0:        CSR_GIO_CHICKEN_BITS: 0X27800200
>> iwlwifi 0000:04:00.0:             CSR_ANA_PLL_CFG: 0X00880300
>> iwlwifi 0000:04:00.0:           CSR_HW_REV_WA_REG: 0X0001001a
>> iwlwifi 0000:04:00.0:        CSR_DBG_HPET_MEM_REG: 0Xffff0000
>> iwlwifi 0000:04:00.0: FH register values:
>> iwlwifi 0000:04:00.0:         FH_RSCSR_CHNL0_STTS_WPTR_REG: 0X11672c00
>> iwlwifi 0000:04:00.0:        FH_RSCSR_CHNL0_RBDCB_BASE_REG: 0X011672b0
>> iwlwifi 0000:04:00.0:                  FH_RSCSR_CHNL0_WPTR: 0X00000098
>> iwlwifi 0000:04:00.0:         FH_MEM_RCSR_CHNL0_CONFIG_REG: 0X00819104
>> iwlwifi 0000:04:00.0:          FH_MEM_RSSR_SHARED_CTRL_REG: 0X000000fc
>> iwlwifi 0000:04:00.0:            FH_MEM_RSSR_RX_STATUS_REG: 0X02630000
>> iwlwifi 0000:04:00.0:    FH_MEM_RSSR_RX_ENABLE_ERR_IRQ2DRV: 0X00000000
>> iwlwifi 0000:04:00.0:                FH_TSSR_TX_STATUS_REG: 0X07ff0001
>> iwlwifi 0000:04:00.0:                 FH_TSSR_TX_ERROR_REG: 0X00000000
>> iwlwifi 0000:04:00.0: Start IWL Event Log Dump: display last 20 entries
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475497643:0x00000000:0210
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475497653:0x00000000:0207
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475497655:0x01002111:0211
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475497660:0x00000000:0212
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475498758:0x00000000:0215
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475498760:0x00000008:0220
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475498779:0x00000000:0301
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475498967:0x00000000:0355
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499319:0x00001359:0217
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499323:0x0b58001c:0218
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499401:0x0b59001c:0206
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499402:0x00000001:0204
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499405:0x01102100:0209
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499430:0x00000000:0210
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499446:0x00000000:0207
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499449:0x2b110000:0227
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499449:0xc3f02b50:0228
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475499454:0x57f255be:1586
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475699376:0x000000d7:0123
>> iwlwifi 0000:04:00.0: EVT_LOGT:1475699415:0x00000000:0125
>> ieee80211 phy0: Hardware restart was requested
>> iwlwifi 0000:04:00.0: L1 Enabled; Disabling L0S
>> iwlwifi 0000:04:00.0: Radio type=0x0-0x2-0x0
>>
>>
>> 04:00.0 Network controller: Intel Corporation Ultimate N WiFi Link 5300
>>
>>       Dave
>>
>> _______________________________________________
>> ilw mailing list
>> ilw@linux.intel.com
>> http://linux.intel.com/mailman/listinfo/ilw
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
