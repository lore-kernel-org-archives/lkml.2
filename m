Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947Ab2KZQ1s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Nov 2012 11:27:48 -0500
Received: from mail-ie0-f174.google.com ([209.85.223.174]:50421 "EHLO
	mail-ie0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754521Ab2KZQ1r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Nov 2012 11:27:47 -0500
MIME-Version: 1.0
In-Reply-To: <20121120084758.GA29199@core.coreip.homeip.net>
References: <9f07bb7dbf29978970d901bbe89add0a333cc925.1352381962.git.viresh.kumar@linaro.org>
	<27d9eea3815593df228c85958096bc14d7985e7e.1352381962.git.viresh.kumar@linaro.org>
	<CAKohpomky4s0OBYtQhDTZc9OeSo6w_mN9uAqUXpukqR1icvKPA@mail.gmail.com>
	<CAKohpoknJqMzro4gbTH+Rh=T2Bc9ZOVmDbYZsqC4Fjq2Sqsszg@mail.gmail.com>
	<20121120084758.GA29199@core.coreip.homeip.net>
Date: Mon, 26 Nov 2012 21:57:45 +0530
Message-ID: <CAKohpon44N8uhEiPEp0Sp8rKAE597Y8A3-YsRFTAZZz4XE8hDw@mail.gmail.com>
Subject: Re: [PATCH 2/3] Input: spear-keyboard: Add clk_{un}prepare() support
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        spear-devel@list.st.com, Vipul Kumar Samar <vipulkumar.samar@st.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 20 November 2012 14:17, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> No, not really, it just does not work well with devm_* patches that got
> applied: on removal you unprepare clock as the very first operation and
> then devm_* does the rest which is wrong order.
>
> I am looking at adding dem_* for clocks.

I haven't seen your clock patch in your tree. I am asking because i want to
push this patch :)

You want me to repost it over your patches.

--
viresh
