Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234Ab2HaXc5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Aug 2012 19:32:57 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:36800 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755170Ab2HaXc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Aug 2012 19:32:56 -0400
MIME-Version: 1.0
In-Reply-To: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
References: <1346415691-13371-1-git-send-email-ulf.hansson@stericsson.com>
Date: Sat, 1 Sep 2012 01:32:55 +0200
Message-ID: <CACRpkdbymhVyWrvRpoZHYp9FanO1As0dnEVJ5tSQm9AGE6-gBQ@mail.gmail.com>
Subject: Re: [PATCH 0/4] clk: Support for smp_twd clock for ux500
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@stericsson.com>,
        Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>
Cc: linux-arm-kernel@lists.infradead.org, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 31, 2012 at 2:21 PM, Ulf Hansson <ulf.hansson@stericsson.com> wrote:

> From: Ulf Hansson <ulf.hansson@linaro.org>
>
> To implement support for the smp_twd clock for ux500 several steps
> was needed. This patchseries has also proposed some new changes in the
> common clock core, which the ux500 smp_twd clock definition are
> relying on.

This is a great series,
Acked-by: Linus Walleij <linus.walleij@linaro.org>
For the ux500 parts.

Mike it'd be great if you could merge this once you have the semantics
of [1/4] sorted out with Ulf.

Yours,
Linus Walleij
