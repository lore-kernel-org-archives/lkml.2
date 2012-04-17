Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755108Ab2DQBrC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Apr 2012 21:47:02 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:43784 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751751Ab2DQBrA convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Apr 2012 21:47:00 -0400
MIME-Version: 1.0
In-Reply-To: <CAJOA=zMPQK-W_nbRztXCNdLHoTJU73ZnrxAS8VvvmzgdaVS2mQ@mail.gmail.com>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
	<1334192572-12499-14-git-send-email-mturquette@linaro.org>
	<20120412064920.GH2445@S2101-09.ap.freescale.net>
	<CAJOA=zMPQK-W_nbRztXCNdLHoTJU73ZnrxAS8VvvmzgdaVS2mQ@mail.gmail.com>
Date: Tue, 17 Apr 2012 09:46:58 +0800
Message-ID: <CAAQ0ZWRg2jwNZ7Bx5j5NtCVveT_085VmFtPMhWW62-aO+kFfnw@mail.gmail.com>
Subject: Re: [PATCH 13/13] clk: basic: improve parent_names & return errors
From: Shawn Guo <shawn.guo@linaro.org>
To: "Turquette, Mike" <mturquette@ti.com>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>, Rajendra Nayak <rnayak@ti.com>,
        linux-kernel@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>,
        Olof Johansson <olof@lixom.net>, linaro-dev@lists.linaro.org,
        arnd.bergmann@linaro.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 April 2012 07:10, Turquette, Mike <mturquette@ti.com> wrote:
...
> Yes, this was a braindead change on my part.  I'll remove the kstrdup
> in my next series (the rest of this patch will stay in).
>
Do you have an ETA on that?  A few platform porting are waiting for a
stable branch with all necessary fixup/cleanup integrated to publish
the patches.

Regards,
Shawn
