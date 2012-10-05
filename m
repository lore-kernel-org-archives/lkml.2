Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750956Ab2JEGkP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 02:40:15 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:64704 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750847Ab2JEGkL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 02:40:11 -0400
MIME-Version: 1.0
In-Reply-To: <1348497799-32143-2-git-send-email-ulf.hansson@stericsson.com>
References: <1348497799-32143-1-git-send-email-ulf.hansson@stericsson.com>
	<1348497799-32143-2-git-send-email-ulf.hansson@stericsson.com>
Date: Fri, 5 Oct 2012 08:14:34 +0200
Message-ID: <CACRpkdac1MJ3ou-vWZ9fFgP8c81+0oag+BYMrJygHRcGwv18YA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: dbx500: Export prmcu_request_ape_opp_100_voltage
From: Linus Walleij <linus.walleij@linaro.org>
To: Ulf Hansson <ulf.hansson@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, Mike Turquette <mturquette@ti.com>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Philippe Begnic <philippe.begnic@st.com>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 4:43 PM, Ulf Hansson <ulf.hansson@stericsson.com> wrote:

> From: Ulf Hansson <ulf.hansson@linaro.org>
>
> This function needs to be exported to let clients be able to
> request the ape opp 100 voltage.
>
> Cc: Samuel Ortiz <sameo@linux.intel.com>
> Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>

Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
