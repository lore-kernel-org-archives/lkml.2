Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752549Ab2G0Wza (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jul 2012 18:55:30 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:37515 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752358Ab2G0Wz3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jul 2012 18:55:29 -0400
MIME-Version: 1.0
In-Reply-To: <1342603220-13287-4-git-send-email-peter.ujfalusi@ti.com>
References: <1342603220-13287-1-git-send-email-peter.ujfalusi@ti.com>
	<1342603220-13287-4-git-send-email-peter.ujfalusi@ti.com>
Date: Sat, 28 Jul 2012 00:55:28 +0200
Message-ID: <CACRpkdaSM0YafovgUnFcNu=gNJJZ1x2d+QSV+zKRQEO4jC7mfA@mail.gmail.com>
Subject: Re: [PATCH 3/3] gpio: Add basic support for TWL6040 GPOs
From: Linus Walleij <linus.walleij@linaro.org>
To: Peter Ujfalusi <peter.ujfalusi@ti.com>
Cc: Samuel Ortiz <sameo@linux.intel.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        Linus Walleij <linus.walleij@stericsson.com>,
        linux-kernel@vger.kernel.org, Sergio Aguirre <saaguirre@ti.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 18, 2012 at 11:20 AM, Peter Ujfalusi <peter.ujfalusi@ti.com> wrote:

> TWL6040 provides GPO lines to be used for controlling external devices.The number
> of lines different between versions: twl6040 have 3 GPO while TWL6041 have 1.
>
> Signed-off-by: Sergio Aguirre <saaguirre@ti.com>
> Signed-off-by: Peter Ujfalusi <peter.ujfalusi@ti.com>

This looks pretty straight-forward and nice!
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
