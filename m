Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759009Ab2FFVng (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 17:43:36 -0400
Received: from mail-qa0-f46.google.com ([209.85.216.46]:36426 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758771Ab2FFVne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 17:43:34 -0400
MIME-Version: 1.0
In-Reply-To: <1339017960.21725.22.camel@x61.thuisdomein>
References: <1339017960.21725.22.camel@x61.thuisdomein>
Date: Wed, 6 Jun 2012 23:43:33 +0200
Message-ID: <CACRpkdbsF-bdXUEctyG8-npqfzFP4uoxE=hRrjgt_TxMWKAD8w@mail.gmail.com>
Subject: Re: [PATCH] u8500_defconfig: delete CONFIG_AB5500_CORE
From: Linus Walleij <linus.walleij@linaro.org>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 6, 2012 at 11:26 PM, Paul Bolle <pebolle@tiscali.nl> wrote:

> Commit 72fb92200d6c31b9982c06784e4bcff2f5b7d8b6 ("mfd/ab5500: delete
> AB5500 support") deleted the Kconfig symbol AB5500_CORE. Let's also
> delete its last usage in u8500_defconfig.
>
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>

These usually go away over time, it'd be better to make a bigger defconfig
update also adding support for new drivers. Anyway this should go through
the ARM SoC tree if you want it anyway,
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
