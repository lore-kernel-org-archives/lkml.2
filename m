Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754523Ab2DXNIn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Apr 2012 09:08:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37130 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753444Ab2DXNIm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Apr 2012 09:08:42 -0400
MIME-Version: 1.0
In-Reply-To: <1334830824-10908-1-git-send-email-ciminaghi@gnudd.com>
References: <1334830824-10908-1-git-send-email-ciminaghi@gnudd.com>
Date: Tue, 24 Apr 2012 15:08:42 +0200
Message-ID: <CACRpkdYNNCxK8iZFQOpnSfYdtEUkEmMCH3otQf6Q9vPwUadT0w@mail.gmail.com>
Subject: Re: [PATCH] dmaengine/amba-pl08x : reset phychan_hold on terminate all
From: Linus Walleij <linus.walleij@linaro.org>
To: ciminaghi@gnudd.com
Cc: vinod.koul@intel.com, linux-kernel@vger.kernel.org,
        dan.j.williams@intel.com, pgeninatti@soft-in.com,
        acolosimo@soft-in.com, alarosa@openintellect.eu
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 19, 2012 at 12:20 PM,  <ciminaghi@gnudd.com> wrote:

> From: Davide Ciminaghi <ciminaghi@gnudd.com>
>
> When a client calls pl08x_control with DMA_TERMINATE_ALL, it is correct
> to terminate and release the phy channel currently in use (if one is in use),
> but the phychan_hold counter must also be reset (otherwise it could get
> trapped in an unbalanced state).
>
> Signed-off-by: Davide Ciminaghi <ciminaghi@gnudd.com>

Can't test it right now but looks convincingly correct:
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
