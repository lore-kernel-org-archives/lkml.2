Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751382Ab2AZJg0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Jan 2012 04:36:26 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:45838 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750842Ab2AZJgY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Jan 2012 04:36:24 -0500
MIME-Version: 1.0
In-Reply-To: <000a01ccdc0a$00627d20$01277760$%jun@samsung.com>
References: <000a01ccdc0a$00627d20$01277760$%jun@samsung.com>
Date: Thu, 26 Jan 2012 18:36:22 +0900
Message-ID: <CAKYAXd9CE2Gke-NiAeCrRJ03_rC-csiEh736bs5M718PWOVZ8Q@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] mmc: core: Add packed command feature of eMMC4.5
From: Namjae Jeon <linkinjeon@gmail.com>
To: Seungwon Jeon <tgih.jun@samsung.com>
Cc: linux-mmc@vger.kernel.org, Chris Ball <cjb@laptop.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/1/26 Seungwon Jeon <tgih.jun@samsung.com>:
> This patch adds packed command feature of eMMC4.5.
> The maximum number for packing read(or write) is offered
> and exception event relevant to packed command which is
> used for error handling is enabled. If host wants to use
> this feature, MMC_CAP2_PACKED_CMD should be set.
>
> Signed-off-by: Seungwon Jeon <tgih.jun@samsung.com>
Reviewed-by: Namjae Jeon <linkinjeon@gmail.com>

Looks good to me.
Thanks.
> ---
