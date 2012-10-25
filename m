Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759989Ab2JYQHG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Oct 2012 12:07:06 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33931 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759905Ab2JYQHB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Oct 2012 12:07:01 -0400
MIME-Version: 1.0
In-Reply-To: <1350272844-21866-1-git-send-email-shijie8@gmail.com>
References: <1350272844-21866-1-git-send-email-shijie8@gmail.com>
Date: Thu, 25 Oct 2012 09:07:00 -0700
Message-ID: <CAN8TOE9BAHUFZf0pW7RvE4B0gbQgXNywQi9mvRgP_f3MKMmtuA@mail.gmail.com>
Subject: Re: [PATCH] mtd: use the NAND_STATUS_FAIL to replace the hardcode
From: Brian Norris <computersforpeace@gmail.com>
To: Huang Shijie <shijie8@gmail.com>
Cc: dwmw2@infradead.org, linux-mtd@lists.infradead.org,
        linux-kernel@vger.kernel.org, dedekind1@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

FWIW

On Sun, Oct 14, 2012 at 8:47 PM, Huang Shijie <shijie8@gmail.com> wrote:
> Use the NAND_STATUS_FAIL to replace the hardcode "0x01",
> which make the code more readable.
>
> Signed-off-by: Huang Shijie <shijie8@gmail.com>

Acked-by: Brian Norris <computersforpeace@gmail.com>
