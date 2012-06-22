Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756076Ab2FVSlh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jun 2012 14:41:37 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:43289 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752779Ab2FVSld (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jun 2012 14:41:33 -0400
Message-ID: <4FE4BC59.20400@pobox.com>
Date: Fri, 22 Jun 2012 14:41:29 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v5 0/13] SATA ZPODD support
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/18/2012 02:25 AM, Lin Ming wrote:
> Hi all,
>
> This is the v5 patches to add SATA ZPODD support, to try it:
> git pull git://git.kernel.org/pub/scm/linux/kernel/git/mlin/linux.git zpodd
>
> Holger and Mathtew,
> Patch 1 to Patch 4 are the libata acpi binding patches from you.
> I removed dock related code from your original version.
> Would you help to review?
>
> v5:
> - rebase to v3.5-rc3
> - fixed crash reported at https://lkml.org/lkml/2012/2/24/2 (Aaron Lu)
> - rename is_pci_ata to compat_pci_ata (Alan Cox)
>
> v4:
> https://lkml.org/lkml/2012/5/28/11
> - Includes libata acpi binding patches from Holger Macht and Matthew Garrett.
> - tell scsi layer device supports runtime power off
> - check support for device busy class events

In the case of this patchset, the main worry are the crashes that were 
introduced by the Macht/Garrett patchset.  Finally with v5 that 
longstanding problem has been resolved, so we can move forward and get 
this into linux-next (libata-dev.git#upstream).

	Jeff




