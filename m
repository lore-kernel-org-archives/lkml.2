Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab2HVLup (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 07:50:45 -0400
Received: from mail-vb0-f46.google.com ([209.85.212.46]:51013 "EHLO
	mail-vb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086Ab2HVLu3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 07:50:29 -0400
MIME-Version: 1.0
In-Reply-To: <1345625042-5678-1-git-send-email-linus.walleij@stericsson.com>
References: <1345625042-5678-1-git-send-email-linus.walleij@stericsson.com>
Date: Wed, 22 Aug 2012 13:50:28 +0200
Message-ID: <CACRpkdY=n=a=FEzLOp-KpjjcgeP+RqHM+DC_eVJf0KrHR7ytyA@mail.gmail.com>
Subject: Re: [PATCH 3/7] gpio/ab8500: MASK_ON_SUSPEND
From: Linus Walleij <linus.walleij@linaro.org>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Etienne Carriere <etienne.carriere@stericsson.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 22, 2012 at 10:44 AM, Linus Walleij
<linus.walleij@stericsson.com> wrote:

> ux500 machines performs pins (GPIO) reconfiguration when entering
> in the suspended mode. This reconfiguration aims at reaching an ultra
> low power HW configuration.

Sam, please disregard this patch.

Yours,
Linus Walleij
