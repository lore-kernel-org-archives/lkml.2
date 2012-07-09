Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753192Ab2GIUY7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 16:24:59 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:41653 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753081Ab2GIUY5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 16:24:57 -0400
MIME-Version: 1.0
In-Reply-To: <201207072358.21943.rjw@sisk.pl>
References: <201207062238.08013.rjw@sisk.pl>
	<201207072358.21943.rjw@sisk.pl>
Date: Mon, 9 Jul 2012 22:24:56 +0200
Message-ID: <CACRpkdaMv6ru6aAA_UiOopKzHjmAhpq=DZf5A0CZ+TMKmv6MqQ@mail.gmail.com>
Subject: Re: [PATCH][update] PM / crypto / ux500: Use struct dev_pm_ops for
 power management
From: Linus Walleij <linus.walleij@linaro.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Srinidhi Kasagar <srinidhi.kasagar@stericsson.com>,
        Linus Walleij <linus.walleij@stericsson.com>,
        Arun MURTHY <arun.murthy@stericsson.com>,
        Andreas WESTIN <andreas.westin@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jul 7, 2012 at 11:58 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

> From: Rafael J. Wysocki <rjw@sisk.pl>
>
> Make the ux500 crypto driver define its PM callbacks through
> struct dev_pm_ops objects rather than by using legacy PM hooks
> in struct platform_driver.
>
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Makes perfect sense to me.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
