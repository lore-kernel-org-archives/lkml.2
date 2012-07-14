Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab2GNUps (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jul 2012 16:45:48 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:57028 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753437Ab2GNUpB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jul 2012 16:45:01 -0400
MIME-Version: 1.0
In-Reply-To: <CAF0AtAs8euY79y-JmD8Bk4oX-8+gwPKsr_JJin+853EesrUTcg@mail.gmail.com>
References: <cover.1341925681.git.cmahapatra@ti.com>
	<f77496c24aa05320ad8cdc81759dd16d7bbb9d65.1341925681.git.cmahapatra@ti.com>
	<CACRpkdYZRzK4jTiQxra46KgSt8x1Vrq4GCFWyc62e303HVoZ+w@mail.gmail.com>
	<CAF0AtAs8euY79y-JmD8Bk4oX-8+gwPKsr_JJin+853EesrUTcg@mail.gmail.com>
Date: Sat, 14 Jul 2012 22:44:59 +0200
Message-ID: <CACRpkdaPCf7eo5V3pHvVE=JFuZp=otXjvQ1US1bHXQ7D1QbDeQ@mail.gmail.com>
Subject: Re: [PATCH 3/4] OMAP: Define TCA6424 max number of possible IRQs
From: Linus Walleij <linus.walleij@linaro.org>
To: "Mahapatra, Chandrabhanu" <cmahapatra@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, grant.likely@secretlab.ca,
        linus.walleij@stericsson.com, rob.herring@calxeda.com,
        linux-kernel@vger.kernel.org, devicetree-discuss@lists.ozlabs.org,
        leed.aguilar@ti.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 12, 2012 at 3:00 PM, Mahapatra, Chandrabhanu
<cmahapatra@ti.com> wrote:

> OK, but if your taking this patch through GPIO tree the better if the 4th
> patch is taken through it. TCA6424 fails if both the patches are not
> present.

If the situation is such they should be squashed into one since the
point after the first before the second patch is not bisectable.

Yours,
Linus Walleij
