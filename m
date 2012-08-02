Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752724Ab2HBPw3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 11:52:29 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39152 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751427Ab2HBPw2 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 11:52:28 -0400
MIME-Version: 1.0
In-Reply-To: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
Date: Thu, 2 Aug 2012 12:52:27 -0300
Message-ID: <CAOMZO5C0=eXYU8Vgnn0xGviXfLEjGgA0yn120NKpwL55m5rgbA@mail.gmail.com>
Subject: Re: [PATCH 0/7] Add support for Freescale's mc34708 to mc13xxx driver
From: Fabio Estevam <festevam@gmail.com>
To: =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>
Cc: Samuel Ortiz <samuel.ortiz@intel.com>,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Marc Reilly <marc@cpdesign.com.au>,
        linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Uwe,

On Thu, Jul 12, 2012 at 6:57 AM, Uwe Kleine-König
<u.kleine-koenig@pengutronix.de> wrote:
> Hello,
>
> This series was tested on a Phytec pcm038 (mc13783 on spi) using
> traditional boot (i.e. not dt) and on a i.MX53 based machine (mc34708 on
> i2c) using dt boot.
>
> Philippe's patches are already in next, they are just included here for
> those who want to test the patches. The 'mfd/mc13xxx: drop modifying
> driver's id_table in probe' was already sent out yesterday and is
> included here because the last patch depends on it.

Would you have a git tree with all these patches applied so that I can
easily test it on a mx53loco board?

Thanks,

Fabio Estevam
