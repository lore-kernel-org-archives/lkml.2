Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932430Ab2EVUEz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:04:55 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:64140 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab2EVUEn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:04:43 -0400
Message-ID: <4FBBF158.2040001@pobox.com>
Date: Tue, 22 May 2012 16:04:40 -0400
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, alan@linux.intel.com
Subject: Re: [PATCH] ata_generic: Skip is_intel_ider() check when ata_generic=1
 is set
References: <1336754003-31487-1-git-send-email-andi@firstfloor.org>
In-Reply-To: <1336754003-31487-1-git-send-email-andi@firstfloor.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2012 12:33 PM, Andi Kleen wrote:
> From: Andi Kleen<ak@linux.intel.com>
>
> When ata_generic_ide=1 is set don't do the is_intel_ider() magic
> check. We found at least one box who needed that.
>
> Cc: alan@linux.intel.com
> Signed-off-by: Andi Kleen<ak@linux.intel.com>
> ---
>   drivers/ata/ata_generic.c |    2 +-
>   1 files changed, 1 insertions(+), 1 deletions(-)

applied


