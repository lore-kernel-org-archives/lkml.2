Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757006Ab2E3HTo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:19:44 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60205 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756945Ab2E3HTn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:19:43 -0400
MIME-Version: 1.0
In-Reply-To: <1338353260-10097-23-git-send-email-lee.jones@linaro.org>
References: <1338353260-10097-1-git-send-email-lee.jones@linaro.org>
	<1338353260-10097-23-git-send-email-lee.jones@linaro.org>
Date: Wed, 30 May 2012 15:19:42 +0800
Message-ID: <CACRpkdYieu5BOR4c=nnGm4MLu26oYb0pLU2=UtgvEMH+=RdfaA@mail.gmail.com>
Subject: Re: [PATCH 22/22] mfd: Enable DT probing of the DB8500 PRCMU
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, arnd@arndb.de,
        linus.walleij@stericsson.com, grant.likely@secretlab.ca,
        cjb@laptop.org, broonie@opensource.wolfsonmicro.com,
        sameo@linux.intel.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 30, 2012 at 12:47 PM, Lee Jones <lee.jones@linaro.org> wrote:

> This patch adds the correct compatible string for use during Device Tree
> population. Without it the DB8500 PRCMU will not be probed.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
