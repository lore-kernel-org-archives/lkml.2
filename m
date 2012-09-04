Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756489Ab2IDH00 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Sep 2012 03:26:26 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:37898 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753004Ab2IDH0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Sep 2012 03:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <1346558339.7253.1.camel@phoenix>
References: <1346558287.7253.0.camel@phoenix>
	<1346558339.7253.1.camel@phoenix>
Date: Tue, 4 Sep 2012 09:26:24 +0200
Message-ID: <CACRpkdZaFQoF-YF+GVH-OWS+YmDZCdbVQ9tLMJQiDnK_MMFFAQ@mail.gmail.com>
Subject: Re: [PATCH 2/2] gpio: wm8350: Convert to use devm_kzalloc API
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 2, 2012 at 5:58 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied, thanks!
Linus Walleij
