Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752922Ab2HAMJf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 08:09:35 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33222 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751082Ab2HAMJe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 08:09:34 -0400
Message-ID: <50191C46.4090902@mvista.com>
Date: Wed, 01 Aug 2012 16:08:38 +0400
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:14.0) Gecko/20120713 Thunderbird/14.0
MIME-Version: 1.0
To: Cyril Chemparathy <cyril@ti.com>
CC: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux@arm.linux.org.uk, arnd@arndb.de, nico@linaro.org,
        catalin.marinas@arm.com, will.deacon@arm.com,
        Vitaly Andrianov <vitalya@ti.com>
Subject: Re: [PATCH 06/22] ARM: LPAE: use phys_addr_t in alloc_init_pud()
References: <1343775898-28345-1-git-send-email-cyril@ti.com> <1343775898-28345-7-git-send-email-cyril@ti.com>
In-Reply-To: <1343775898-28345-7-git-send-email-cyril@ti.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 01-08-2012 3:04, Cyril Chemparathy wrote:

> From: Vitaly Andrianov <vitalya@ti.com>

> This patch fixes the alloc_init_pud() function to use phys_addr_t instead of
> unsigned long when passing in the phys argument.

> This is an extension to commit 97092e0c56830457af0639f6bd904537a150ea4a, which

    Please also specify that commit's summary in parens.

> applied similar changes elsewhere in the ARM memory management code.

> Signed-off-by: Vitaly Andrianov <vitalya@ti.com>
> Signed-off-by: Cyril Chemparathy <cyril@ti.com>

WBR, Sergei

