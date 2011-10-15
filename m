Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751462Ab1JOG2z (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Oct 2011 02:28:55 -0400
Received: from beauty.rexursive.com ([150.101.121.179]:33823 "EHLO
	beauty.rexursive.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751136Ab1JOG2y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Oct 2011 02:28:54 -0400
Subject: Re: [PATCH v8]: Improve performance of LZO/plain hibernation
From: Bojan Smojver <bojan@rexursive.com>
To: Pekka Enberg <penberg@cs.helsinki.fi>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-kernel@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        Keith Packard <keithp@keithp.com>
Date: Sat, 15 Oct 2011 17:28:51 +1100
In-Reply-To: <CAOJsxLF2Qo0UK8wCg1mt2Awiv7k=XPA9kHMy808f++FXibi4QA@mail.gmail.com>
References: <1317342456.1959.6.camel@shrek.rexursive.com>
	 <201110062045.48689.rjw@sisk.pl> <2409186928.1003010428@rexursive.com>
	 <201110132326.02041.rjw@sisk.pl>
	 <1318557712.2027.1.camel@shrek.rexursive.com>
	 <CAOJsxLF2Qo0UK8wCg1mt2Awiv7k=XPA9kHMy808f++FXibi4QA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1318660131.2027.2.camel@shrek.rexursive.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-10-14 at 09:14 +0300, Pekka Enberg wrote:
> What debugging options do you have enabled?

This is what grep of DEBUG prints:
-------------------
CONFIG_ARCH_SUPPORTS_DEBUG_PAGEALLOC=y
CONFIG_SLUB_DEBUG=y
CONFIG_HAVE_DMA_API_DEBUG=y
CONFIG_XEN_DEBUG_FS=y
CONFIG_X86_DEBUGCTLMSR=y
CONFIG_PM_DEBUG=y
CONFIG_PM_ADVANCED_DEBUG=y
CONFIG_ACPI_EC_DEBUGFS=m
CONFIG_L2TP_DEBUGFS=m
CONFIG_CFG80211_DEBUGFS=y
CONFIG_MAC80211_DEBUGFS=y
CONFIG_WIMAX_DEBUG_LEVEL=8
CONFIG_DEBUG_DEVRES=y
CONFIG_CB710_DEBUG_ASSUMPTIONS=y
CONFIG_IWMC3200TOP_DEBUGFS=y
CONFIG_AIC7XXX_DEBUG_MASK=0
CONFIG_AIC79XX_DEBUG_MASK=0
CONFIG_SCSI_DEBUG=m
CONFIG_DM_DEBUG=y
CONFIG_FIREWIRE_OHCI_DEBUG=y
CONFIG_MLX4_DEBUG=y
CONFIG_ATH5K_DEBUG=y
CONFIG_ATH9K_DEBUGFS=y
CONFIG_IWLWIFI_DEBUG=y
CONFIG_IWLWIFI_DEBUGFS=y
CONFIG_IWLWIFI_LEGACY_DEBUG=y
CONFIG_IWLWIFI_LEGACY_DEBUGFS=y
CONFIG_RT2X00_LIB_DEBUGFS=y
CONFIG_WIMAX_I2400M_DEBUG_LEVEL=8
CONFIG_SND_DEBUG=y
CONFIG_SND_PCM_XRUN_DEBUG=y
CONFIG_USB_SERIAL_DEBUG=m
CONFIG_INFINIBAND_MTHCA_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG=y
CONFIG_INFINIBAND_IPOIB_DEBUG_DATA=y
CONFIG_DRM_NOUVEAU_DEBUG=y
CONFIG_JFFS2_FS_DEBUG=0
CONFIG_DLM_DEBUG=y
CONFIG_DEBUG_FS=y
CONFIG_DEBUG_KERNEL=y
CONFIG_DEBUG_SHIRQ=y
CONFIG_SCHED_DEBUG=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_DEBUG_MEMORY_INIT=y
CONFIG_DEBUG_LIST=y
CONFIG_DYNAMIC_DEBUG=y
CONFIG_DEBUG_STACKOVERFLOW=y
CONFIG_DEBUG_RODATA=y
CONFIG_DEBUG_RODATA_TEST=y
CONFIG_DEBUG_NX_TEST=m
CONFIG_DEBUG_BOOT_PARAMS=y
CONFIG_KEYS_DEBUG_PROC_KEYS=y
-------------------

-- 
Bojan

