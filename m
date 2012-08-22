Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757829Ab2HVXmP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 19:42:15 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:44713 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756637Ab2HVXmM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 19:42:12 -0400
Message-ID: <50356E4E.4060304@pobox.com>
Date: Wed, 22 Aug 2012 19:42:06 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Kent Yoder <key@linux.vnet.ibm.com>, James Morris <jmorris@namei.org>
CC: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net, adlai@linux.vnet.ibm.com,
        xiaoyan.zhang@intel.com, jj@chaosbits.net, peter.huewe@infineon.com
Subject: Re: [GIT PULL] tpmdd: TPM drivers, tpm-rng and fixes
References: <20120822215216.GC13519@linux.vnet.ibm.com>
In-Reply-To: <20120822215216.GC13519@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/22/2012 05:52 PM, Kent Yoder wrote:
>    Hi James,
>
> The following changes since commit 51b743fe87d7fb3dba7a2ff4a1fe23bb65dc2245:
>
>    Merge tag 'v3.6-rc2' into next (2012-08-17 20:42:30 +1000)
>
> are available in the git repository at:
>
>    git://github.com/shpedoikal/linux.git v3.6-rc2-tpmdd
>
> New stuff since my last pull request are Jesper's error checking of the
> acpi_os_map_memory call, Ashley's vTPM driver for PPC64, my enabling the
> vTPM driver when IMA is selected on PPC64 and Xiaoyan's addition of
> Physical Presence Interface.
>
> Thanks,
> Kent
>
> Ashley Lai (3):
>        drivers/char/tpm: Add new device driver to support IBM vTPM
>        PPC64: Add support for instantiating SML from Open Firmware
>        drivers/char/tpm: Add securityfs support for event log
>
> Jesper Juhl (1):
>        tpm: Do not dereference NULL pointer if acpi_os_map_memory() fails.
>
> Kent Yoder (6):
>        tpm: modularize event log collection
>        tpm: Move tpm_get_random api into the TPM device driver
>        hw_random: add support for the TPM chip as a hardware RNG source
>        tpm: fix double write race and tpm_release free issue
>        tpm: compile out unused code in the PNP and PM cases
>        ima: enable the IBM vTPM as the default TPM in the PPC64 case
>
> Peter Huewe (1):
>        char/tpm: Add new driver for Infineon I2C TIS TPM
>
> Xiaoyan Zhang (2):
>        Documentation: sysfs for Physical Presence Interface
>        driver: add PPI support in tpm driver

+1 for tpm-rng



