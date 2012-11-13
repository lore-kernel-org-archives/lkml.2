Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755201Ab2KMOek (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 09:34:40 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:41108 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755180Ab2KMOei (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 09:34:38 -0500
MIME-Version: 1.0
In-Reply-To: <1352702808.15066.5.camel@phoenix>
References: <1352702750.15066.4.camel@phoenix>
	<1352702808.15066.5.camel@phoenix>
Date: Tue, 13 Nov 2012 15:34:37 +0100
Message-ID: <CACRpkdayvjO-i3XkpKEw6zCjBzqkTrw9KPVdad1yGNUtK16OSA@mail.gmail.com>
Subject: Re: [PATCH 2/2] pinctrl: pxa3xx: Remove phy_base and phy_size from
 struct pxa3xx_pinmux_info
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@ingics.com>
Cc: Haojian Zhuang <haojian.zhuang@gmail.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 12, 2012 at 7:46 AM, Axel Lin <axel.lin@ingics.com> wrote:

> They are not used, remove them.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Applied, thanks!
Linus Walleij
