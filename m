Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756087Ab1AaQGG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Jan 2011 11:06:06 -0500
Received: from mail-ew0-f46.google.com ([209.85.215.46]:63210 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab1AaQGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Jan 2011 11:06:04 -0500
Message-ID: <4D46DD95.3000006@ru.mvista.com>
Date: Mon, 31 Jan 2011 19:04:37 +0300
From: Sergei Shtylyov <sshtylyov@mvista.com>
User-Agent: Thunderbird 2.0.0.21 (X11/20090320)
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ata: pata: Convert pr_*(DRV_NAME ...) to pr_fmt/pr_<level>
References: <201101310359.p0V3x41L010660@hera.kernel.org> <1296448498.4131.22.camel@Joe-Laptop>
In-Reply-To: <1296448498.4131.22.camel@Joe-Laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

Joe Perches wrote:

> Commit 40d69ba029c8d5de51aaeb5358999266c482d00a
> ("pata_hpt{37x|3x2n}: use pr_*(DRV_NAME ...) instead of printk(KERN_* ...)")
> used pr_<level>.

> Add #define pr_fmt and remove DRV_NAME.

> Signed-off-by: Joe Perches <joe@perches.com>

    Could you also increment the driver versions?

WBR, Sergei
