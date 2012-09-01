Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755482Ab2IAKz5 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Sep 2012 06:55:57 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:62744 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752329Ab2IAKz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Sep 2012 06:55:56 -0400
MIME-Version: 1.0
In-Reply-To: <1346492667.10234.3.camel@phoenix>
References: <1346492667.10234.3.camel@phoenix>
Date: Sat, 1 Sep 2012 12:55:55 +0200
Message-ID: <CACRpkdZzyfXz0ECmEEA2WfPDU7wnEHKsKje5Ff43P9AzS4yajA@mail.gmail.com>
Subject: Re: [PATCH] gpio: tps65912: Convert to use devm_kzalloc API
From: Linus Walleij <linus.walleij@linaro.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        Margarita Olaya <magi@slimlogic.co.uk>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Sep 1, 2012 at 11:44 AM, Axel Lin <axel.lin@gmail.com> wrote:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>

Applied.

Thanks,
Linus Walleij
