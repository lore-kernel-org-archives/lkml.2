Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932366Ab2HOUAx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Aug 2012 16:00:53 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:42859 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932185Ab2HOUAs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Aug 2012 16:00:48 -0400
Date: Wed, 15 Aug 2012 14:59:37 -0500
From: Kent Yoder <key@linux.vnet.ibm.com>
To: Ashley Lai <adlai@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, benh@kernel.crashing.org,
        linuxppc-dev@lists.ozlabs.org, rcj@linux.vnet.ibm.com,
        adlai@us.ibm.com
Subject: Re: [PATCH V3 0/3] tpm: Add new vTPM device driver for PPC64
Message-ID: <20120815195937.GA27618@linux.vnet.ibm.com>
References: <1344986638.4430.22.camel@footlong>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1344986638.4430.22.camel@footlong>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12081520-2398-0000-0000-0000097A1D3A
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 14, 2012 at 06:23:58PM -0500, Ashley Lai wrote:
> Change log V3:
> - Replaced TPM_NO_EVENT_LOG macro with stubs
> - Removed tpm_noeventlog.c file 
> - Called of_node_put() before return in tpm_of.c
> 
> Change log V2:
> - Removed unnecessary tpm_bios_log_setup and tpm_bios_log_teardown
>   functions in tpm_eventlog.h (patch 3/3).
> - Added more descriptions on vTPM (patch 1/3).
> 
> These patches add support for IBM vTPM for PPC64. This new device driver
> works on firmware that supports vTPM (firmware release 740 or higher).
> 
> Tested on Power7+ system with firmware level ZM770_001.
> 
> Applied to Kent Yoder tree at:
> https://github.com/shpedoikal/linux/tree/v3.6-rc1-tpmdd-staging

  Thanks Ashley, I've added the patches to that tree.

Kent

> 
> Ashley Lai (3):
>   drivers/char/tpm: Add new device driver to support IBM vTPM
>   PPC64: Add support for instantiating SML from Open Firmware
>   drivers/char/tpm: Add securityfs support for event log
> 
>  arch/powerpc/kernel/prom_init.c |   62 ++++
>  drivers/char/tpm/Kconfig        |    8 +
>  drivers/char/tpm/Makefile       |    6 +
>  drivers/char/tpm/tpm.h          |   13 +-
>  drivers/char/tpm/tpm_eventlog.h |   15 +
>  drivers/char/tpm/tpm_ibmvtpm.c  |  749 +++++++++++++++++++++++++++++++++++++++
>  drivers/char/tpm/tpm_ibmvtpm.h  |   83 +++++
>  drivers/char/tpm/tpm_of.c       |   73 ++++
>  8 files changed, 997 insertions(+), 12 deletions(-)
>  create mode 100644 drivers/char/tpm/tpm_ibmvtpm.c
>  create mode 100644 drivers/char/tpm/tpm_ibmvtpm.h
>  create mode 100644 drivers/char/tpm/tpm_of.c
> 
> 

