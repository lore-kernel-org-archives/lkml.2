Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752182Ab2E2MW7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 May 2012 08:22:59 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:53927 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751163Ab2E2MW4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 May 2012 08:22:56 -0400
Message-ID: <4FC4BF80.2090900@mvista.com>
Date: Tue, 29 May 2012 16:22:24 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Jeff Garzik <jgarzik@pobox.com>,
        David Woodhouse <David.Woodhouse@intel.com>,
        Aaron Lu <aaron.lu@amd.com>, Holger Macht <holger@homac.de>,
        Matthew Garrett <mjg@redhat.com>, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH v4 04/13] libata: use correct PCI devices
References: <1338181720-4149-1-git-send-email-ming.m.lin@intel.com> <1338181720-4149-5-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1338181720-4149-5-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 28-05-2012 9:08, Lin Ming wrote:

> From: Holger Macht<holger@homac.de>

> Commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a

    Please also specify that commit's summary in parens.

> made ata ports parent
> devices of scsi hosts, so we need to go yet another level up to be able
> to use the correct PCI devices.

> Signed-off-by: Holger Macht <holger@homac.de>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

WBR, Sergei
