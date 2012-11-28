Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755055Ab2K1RnD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Nov 2012 12:43:03 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:48127 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754006Ab2K1RnB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Nov 2012 12:43:01 -0500
Message-ID: <50B64D22.2010004@pobox.com>
Date: Wed, 28 Nov 2012 12:42:58 -0500
From: Jeff Garzik <jgarzik@pobox.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121029 Thunderbird/16.0.2
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/16] ata: Convert dev_printk(KERN_<LEVEL> to dev_<level>(
References: <cover.1351411047.git.joe@perches.com> <ff89ae9b42c644728575a3cf606184ab9875d6e9.1351411047.git.joe@perches.com>
In-Reply-To: <ff89ae9b42c644728575a3cf606184ab9875d6e9.1351411047.git.joe@perches.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2012 04:05 AM, Joe Perches wrote:
> dev_<level> calls take less code than dev_printk(KERN_<LEVEL>
> and reducing object size is good.
> Coalesce formats for easier grep.
>
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>   drivers/ata/pata_cmd64x.c |    6 +++---
>   1 files changed, 3 insertions(+), 3 deletions(-)

applied



