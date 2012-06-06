Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758948Ab2FFWH5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jun 2012 18:07:57 -0400
Received: from cpsmtpb-ews09.kpnxchange.com ([213.75.39.14]:1646 "EHLO
	cpsmtpb-ews09.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758667Ab2FFWHd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jun 2012 18:07:33 -0400
Message-ID: <1339020451.21725.33.camel@x61.thuisdomein>
Subject: Re: [PATCH] u8500_defconfig: delete CONFIG_AB5500_CORE
From: Paul Bolle <pebolle@tiscali.nl>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Samuel Ortiz <sameo@linux.intel.com>, linux-kernel@vger.kernel.org,
        Jiri Kosina <trivial@kernel.org>
Date: Thu, 07 Jun 2012 00:07:31 +0200
In-Reply-To: <CACRpkdbsF-bdXUEctyG8-npqfzFP4uoxE=hRrjgt_TxMWKAD8w@mail.gmail.com>
References: <1339017960.21725.22.camel@x61.thuisdomein>
	 <CACRpkdbsF-bdXUEctyG8-npqfzFP4uoxE=hRrjgt_TxMWKAD8w@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 06 Jun 2012 22:07:32.0128 (UTC) FILETIME=[C5347200:01CD4430]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-06-06 at 23:43 +0200, Linus Walleij wrote:
> These usually go away over time,

Maybe they should, but they don't, at least not always. See
https://lkml.org/lkml/2011/11/18/211 in which I suggested to delete
almost 2000 unused macros from over 400 defconfig files. (Jiri - added
to the CC - apparently never pulled these changes. I never reminded Jiri
to do so, so I'm to blame.)

>  it'd be better to make a bigger defconfig
> update also adding support for new drivers. Anyway this should go through
> the ARM SoC tree if you want it anyway,
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

That's fine with me. I hope to resend (sort of) shortly, with your ACK,
to the people in charge of the ARM SoC tree.


Paul Bolle

