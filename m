Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753792Ab2DQHSB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Apr 2012 03:18:01 -0400
Received: from mail-lpp01m010-f46.google.com ([209.85.215.46]:37762 "EHLO
	mail-lpp01m010-f46.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751355Ab2DQHR7 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Apr 2012 03:17:59 -0400
MIME-Version: 1.0
In-Reply-To: <CAJOA=zPnQhq_3O00F4dfUbnywW-Riov7N76F3wraE67yy2MMuA@mail.gmail.com>
References: <1334192572-12499-1-git-send-email-mturquette@linaro.org>
	<1334192572-12499-14-git-send-email-mturquette@linaro.org>
	<20120412064920.GH2445@S2101-09.ap.freescale.net>
	<CAJOA=zMPQK-W_nbRztXCNdLHoTJU73ZnrxAS8VvvmzgdaVS2mQ@mail.gmail.com>
	<CAAQ0ZWRg2jwNZ7Bx5j5NtCVveT_085VmFtPMhWW62-aO+kFfnw@mail.gmail.com>
	<CAJOA=zPnQhq_3O00F4dfUbnywW-Riov7N76F3wraE67yy2MMuA@mail.gmail.com>
Date: Tue, 17 Apr 2012 15:17:57 +0800
Message-ID: <CAAQ0ZWQ_haRN-WHNzTMcjFvryRqjM58QoseC8WejBiqcDfSuPA@mail.gmail.com>
Subject: Re: [PATCH 13/13] clk: basic: improve parent_names & return errors
From: Shawn Guo <shawn.guo@linaro.org>
To: linux-kernel@vger.kernel.org, Saravana Kannan <skannan@codeaurora.org>
Cc: Andrew Lunn <andrew@lunn.ch>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Russell King <linux@arm.linux.org.uk>, patches@linaro.org,
        Sascha Hauer <s.hauer@pengutronix.de>, Rajendra Nayak <rnayak@ti.com>,
        Olof Johansson <olof@lixom.net>, linaro-dev@lists.linaro.org,
        arnd.bergmann@linaro.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17 April 2012 11:50, Turquette, Mike <mturquette@ti.com> wrote:
> That is a good question.  I think it is worth waiting on Saravana's
> patch which exposes non-private members of struct clk via struct
> clk_hw.  This will have an effect on both platform clock data and
> code.

Saravana,

(*nudge*) (*nudge*) goes to you now :)

Regards,
Shawn
