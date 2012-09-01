Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755477Ab2IAKym (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 06:54:42 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:59893 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752211Ab2IAKyl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 06:54:41 -0400
MIME-Version: 1.0
In-Reply-To: <1346492055.10234.1.camel@phoenix>
References: <1346492055.10234.1.camel@phoenix>
Date: Sat, 1 Sep 2012 12:54:40 +0200
Message-ID: <CACRpkdZ5pUy2E2DTnCne46z--5mKfmtRX7GewuYEp_TmgpbNaA@mail.gmail.com>
Subject: Re: [PATCH] gpio: da9052: Convert to use devm_kzalloc API
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        David Dajun Chen <dchen@diasemi.com>,
        Ashish Jangam <ashish.jangam@kpitcummins.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 1, 2012 at 11:34 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

Thanks,
Linus Walleij
