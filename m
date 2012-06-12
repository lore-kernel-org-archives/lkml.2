Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752173Ab2FLLDE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:03:04 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:65471 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750987Ab2FLLDD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:03:03 -0400
MIME-Version: 1.0
In-Reply-To: <1339087766-14739-1-git-send-email-devendra.aaru@gmail.com>
References: <1339087766-14739-1-git-send-email-devendra.aaru@gmail.com>
Date: Tue, 12 Jun 2012 13:03:02 +0200
Message-ID: <CACRpkdbGHxPYRZGBZXFDSCxqNQC32CgF9Dp5c3BEkwtyRAGwBA@mail.gmail.com>
Subject: Re: [PATCH V2 2/2] pinctrl: pinctrl-imx: free if of_get_parent fails
 to get the parent node
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>
Cc: Dong Aisheng <aisheng.dong@freescale.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 7, 2012 at 6:49 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> of_get_parent can return null if no parent node found, so the allocated new_map
> should be freed.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>
> Acked-by: Dong Aisheng <dong.aisheng@linaro.org>

Applied this v2 version, thanks!
Linus Walleij
