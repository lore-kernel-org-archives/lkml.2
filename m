Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753816Ab2JIMTT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 08:19:19 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:50212 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752651Ab2JIMTR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 08:19:17 -0400
MIME-Version: 1.0
In-Reply-To: <CACRpkdZKjOxe3U76+HRrsMU3MBw8TqELWyTug2ciyuS9=FBi5w@mail.gmail.com>
References: <1349320509-26930-1-git-send-email-festevam@gmail.com>
	<1349320509-26930-6-git-send-email-festevam@gmail.com>
	<CACRpkdYTqT=eCOWq7hnymMVg0kab-pkXfv4kxnzSrNCNstpwJw@mail.gmail.com>
	<CAOMZO5BSGFuSg6rMK5cREi3xb47yBm-mW8PDy36nCub9bsFScg@mail.gmail.com>
	<CACRpkdZKjOxe3U76+HRrsMU3MBw8TqELWyTug2ciyuS9=FBi5w@mail.gmail.com>
Date: Tue, 9 Oct 2012 09:19:16 -0300
Message-ID: <CAOMZO5AkSpQRvRcFm_sr+TWWc=aYGT6YJDcigVG_RenpT7_Q6w@mail.gmail.com>
Subject: Re: [PATCH 6/6] gpio: gpio-da9052: Convert to the new da9052
 interrupt functions
From: Fabio Estevam <festevam@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: sameo@linux.intel.com, broonie@opensource.wolfsonmicro.com,
        ashish.jangam@kpitcummins.com, dchen@diasemi.com, arnd@arndb.de,
        kernel@pengutronix.de, linux-kernel@vger.kernel.org,
        Fabio Estevam <fabio.estevam@freescale.com>,
        Grant Likely <grant.likely@secretlab.ca>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 9, 2012 at 9:04 AM, Linus Walleij <linus.walleij@linaro.org> wrote:

> Ah OK I'll take it out again. Push this through whatever tree you
> want (maybe the i.MX or MFD tree then?)
>
> Reviewed-by: Linus Walleij <linus.walleij@linaro.org>

Sascha/Samuel/Arnd,

Which tree could take this patch series, please?

Thanks,

Fabio Estevam
