Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752239Ab1JLQlD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Oct 2011 12:41:03 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:63124 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791Ab1JLQlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Oct 2011 12:41:01 -0400
MIME-Version: 1.0
In-Reply-To: <20110830104955.4b1b8381@v0nbox>
References: <1314402027-11293-1-git-send-email-vivien.didelot@savoirfairelinux.com>
	<1314402027-11293-3-git-send-email-vivien.didelot@savoirfairelinux.com>
	<20110829221132.GB26846@sirena.org.uk>
	<4E5C76E0.4000008@zytor.com>
	<20110830110020.GE2061@opensource.wolfsonmicro.com>
	<20110830104955.4b1b8381@v0nbox>
Date: Wed, 12 Oct 2011 18:41:00 +0200
Message-ID: <CACRpkdYmZc6H6iNp6n8qUizUAHQxNbr32gjtxYe7LSb-bq=Kew@mail.gmail.com>
Subject: Re: [v2 2/4] platform: (TS-5500) add GPIO support
From: Linus Walleij <linus.walleij@linaro.org>
To: Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Grant Likely <grant.likely@secretlab.ca>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Jerome Oufella <jerome.oufella@savoirfairelinux.com>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 4:49 PM, Vivien Didelot
<vivien.didelot@savoirfairelinux.com> wrote:

> Grouping every driver for this platform was one of the main comments of
> my first RFC set of patches. And indeed, the GPIO driver is really
> specific to this platform, so it won't be shared.

What we've seen is that it's no fun for the arch/platform maintainer
when GPIO drivers start to proliferate the arch.

You should have Grants Likelys ACK on this no matter where it
ends up anyway so let's hear what he says?

Yours,
Linus Walleij
