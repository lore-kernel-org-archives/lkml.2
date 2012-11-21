Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab2KUPDo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Nov 2012 10:03:44 -0500
Received: from mail-wg0-f44.google.com ([74.125.82.44]:57565 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754946Ab2KUPDm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Nov 2012 10:03:42 -0500
From: Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH 3/4 v2] gpio/mvebu: convert to use irq_domain_add_simple()
To: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>
In-Reply-To: <1350644042-31793-1-git-send-email-linus.walleij@linaro.org>
References: <1350644042-31793-1-git-send-email-linus.walleij@linaro.org>
Date: Wed, 21 Nov 2012 15:03:38 +0000
Message-Id: <20121121150338.10C9C3E0A47@localhost>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 19 Oct 2012 12:54:02 +0200, Linus Walleij <linus.walleij@linaro.org> wrote:
> The MVEBU driver probably just wants a few IRQs. Using the simple
> domain has the upside of allocating IRQ descriptors if need be,
> especially in a SPARSE_IRQ environment.
> 
> Cc: Rob Herring <rob.herring@calxeda.com>
> Cc: Grant Likely <grant.likely@secretlab.ca>
> Cc: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
> Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
> Cc: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Linus Walleij <linus.walleij@linaro.org>

Applied, thanks.

g.
