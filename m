Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752512Ab2FRLiH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Jun 2012 07:38:07 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:45346 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752260Ab2FRLiD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Jun 2012 07:38:03 -0400
Message-ID: <4FDF12F0.6080205@mvista.com>
Date: Mon, 18 Jun 2012 15:37:20 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: Lin Ming <ming.m.lin@intel.com>
CC: Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lu@amd.com>,
        Holger Macht <holger@homac.de>, Matthew Garrett <mjg@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        David Woodhouse <David.Woodhouse@intel.com>,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v5 04/12] libata: use correct PCI devices
References: <1340000766-129148-1-git-send-email-ming.m.lin@intel.com> <1340000766-129148-5-git-send-email-ming.m.lin@intel.com>
In-Reply-To: <1340000766-129148-5-git-send-email-ming.m.lin@intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 18-06-2012 10:25, Lin Ming wrote:

> From: Holger Macht <holger@homac.de>

> Commit 9a6d6a2ddabbd32c07f6a38b659e5f3db319fa5a

    Please also specify that commit's summary in parens.

> made ata ports parent
> devices of scsi hosts, so we need to go yet another level up to be able
> to use the correct PCI devices.

> Signed-off-by: Holger Macht <holger@homac.de>
> Signed-off-by: Lin Ming <ming.m.lin@intel.com>

MBR, Sergei

