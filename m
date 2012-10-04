Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755755Ab2JDNBY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 09:01:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:55003 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753024Ab2JDNBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 09:01:22 -0400
MIME-Version: 1.0
In-Reply-To: <CAOMZO5AVP1L-6A7cmV-kQEfG1C+vczFKT=sQbFtLJDaGau0kRg@mail.gmail.com>
References: <1342087073-3892-1-git-send-email-u.kleine-koenig@pengutronix.de>
	<11987916.rOoNGcb1ly@dev1>
	<CAOMZO5AVP1L-6A7cmV-kQEfG1C+vczFKT=sQbFtLJDaGau0kRg@mail.gmail.com>
Date: Thu, 4 Oct 2012 10:01:21 -0300
Message-ID: <CAOMZO5BqZpy5Cz0BxbpdOY=sjMjhSOjfQZmJ4j7Xwe6Q7x6Yig@mail.gmail.com>
Subject: Re: [PATCH 0/7] Add support for Freescale's mc34708 to mc13xxx driver
From: Fabio Estevam <festevam@gmail.com>
To: Marc Reilly <marc@cpdesign.com.au>, Samuel Ortiz <samuel.ortiz@intel.com>
Cc: linux-arm-kernel@lists.infradead.org,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        =?UTF-8?Q?Philippe_R=C3=A9tornaz?= <philippe.retornaz@epfl.ch>,
        Arnd Bergmann <arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Samuel,

On Wed, Sep 5, 2012 at 11:22 AM, Fabio Estevam <festevam@gmail.com> wrote:
> Hi Samuel,
>
> On Thu, Jul 12, 2012 at 8:02 PM, Marc Reilly <marc@cpdesign.com.au> wrote:
>> Hi Uwe,
>>
>>> This series was tested on a Phytec pcm038 (mc13783 on spi) using
>>> traditional boot (i.e. not dt) and on a i.MX53 based machine (mc34708 on
>>> i2c) using dt boot.
>>>
>>> Philippe's patches are already in next, they are just included here for
>>> those who want to test the patches. The 'mfd/mc13xxx: drop modifying
>>> driver's id_table in probe' was already sent out yesterday and is
>>> included here because the last patch depends on it.
>>>
>>
>> For all patches (that don't already have it):
>> Acked-by: Marc Reilly <marc@cpdesign.com.au>
>
> Can this series be applied?

Any comments on this series, please?

I want to add mc34708 support to mx53qsb and need this series to be applied.
