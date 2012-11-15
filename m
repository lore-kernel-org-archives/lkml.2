Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1767614Ab2KOLfn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 06:35:43 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:37877 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2993406Ab2KOLfm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 06:35:42 -0500
MIME-Version: 1.0
In-Reply-To: <2773e9204be54157c49811ed2d98a0de352e9c19.1352884427.git.viresh.kumar@linaro.org>
References: <2773e9204be54157c49811ed2d98a0de352e9c19.1352884427.git.viresh.kumar@linaro.org>
Date: Thu, 15 Nov 2012 12:35:41 +0100
Message-ID: <CACRpkdYOnPWA5qUWbi5W23yKsrYjL8oxXEy1826C_Y-6Ks5SUw@mail.gmail.com>
Subject: Re: [PATCH] Pinctrl: SPEAr: Plgpio: Don't call prepare/unprepare on request/free
From: Linus Walleij <linus.walleij@linaro.org>
To: Viresh Kumar <viresh.kumar@linaro.org>
Cc: axel.lin@ingics.com, spear-devel@list.st.com, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 14, 2012 at 10:14 AM, Viresh Kumar <viresh.kumar@linaro.org> wrote:

> SPEAr SoC's don't do anything in clk_prepare() of plgpio driver, so there is no
> need to call this routine multiple times. Just call it once at probe.
>
> Signed-off-by: Viresh Kumar <viresh.kumar@linaro.org>
> ---
> Hi Linus,
>
> This patch is rebased over https://lkml.org/lkml/2012/11/14/220

Nice, patch applied!

Yours,
Linus Walleij
