Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752673Ab2FLLcv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 07:32:51 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:60798 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862Ab2FLLcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 07:32:50 -0400
MIME-Version: 1.0
In-Reply-To: <1339243351-28115-1-git-send-email-devendra.aaru@gmail.com>
References: <1339243351-28115-1-git-send-email-devendra.aaru@gmail.com>
Date: Tue, 12 Jun 2012 13:32:49 +0200
Message-ID: <CACRpkdbCzrPvf+4_Nut1CrvtVe1NzuqjTavddx_sLmMQh+gwnA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: pinctrl-mxs: set platform driver data to
 NULL at errpath and at unregister
From: Linus Walleij <linus.walleij@linaro.org>
To: Devendra Naga <devendra.aaru@gmail.com>,
        Dong Aisheng <B29396@freescale.com>, Shawn Guo <shawn.guo@linaro.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 9, 2012 at 2:02 PM, Devendra Naga <devendra.aaru@gmail.com> wrote:

> clear the platform data pointer when mxs_pinctrl_probe_dt fails,
> and also before the unregistering with pinctrl subsystem.
>
> Signed-off-by: Devendra Naga <devendra.aaru@gmail.com>

Applied this as well.

Yours,
Linus Walleij
