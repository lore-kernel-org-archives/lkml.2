Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756346Ab2FTOQR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 10:16:17 -0400
Received: from mail-qc0-f174.google.com ([209.85.216.174]:62921 "EHLO
	mail-qc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751753Ab2FTOQQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 10:16:16 -0400
MIME-Version: 1.0
In-Reply-To: <20120620103004.GA13194@pengutronix.de>
References: <1337640630-29176-1-git-send-email-rob.lee@linaro.org> <20120620103004.GA13194@pengutronix.de>
From: Rob Lee <rob.lee@linaro.org>
Date: Wed, 20 Jun 2012 09:15:35 -0500
Message-ID: <CAMXH7KGh2RrzTy9+mcYAfbQgcVC0H9=ozXzBb-wCho51pM6CVg@mail.gmail.com>
Subject: Re: [PATCH v5 0/7] cleanup imx5 idle, add imx5/6 cpuidle
To: Sascha Hauer <s.hauer@pengutronix.de>
Cc: kernel@pengutronix.de, shawn.guo@linaro.org,
        u.kleine-koenig@pengutronix.de, richard.zhao@freescale.com,
        amit.kucheria@linaro.org, daniel.lezcano@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linaro-dev@lists.linaro.org, patches@linaro.org, jj@chaosbits.net
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Sascha,

On Wed, Jun 20, 2012 at 5:30 AM, Sascha Hauer <s.hauer@pengutronix.de> wrote:
> Hi Robert,
>
> On Mon, May 21, 2012 at 05:50:23PM -0500, Robert Lee wrote:
>> Cleanup up imx5 idle code and enable imx5 low powe idle for imx53.
>>
>> Add common imx cpuidle initialization functionality and add a i.MX5 and i.MX6Q
>> platform cpuidle implementation.
>
> I rebased this to 3.5-rc1 here:
>
> git.pengutronix.de/git/imx/linux-2.6.git imx/cpuidle
>
> Could you check if the result is ok with you?
>

Certainly.  I will let you know in a day or two.

Rob

> Sascha
>
>
> --
> Pengutronix e.K.                           |                             |
> Industrial Linux Solutions                 | http://www.pengutronix.de/  |
> Peiner Str. 6-8, 31137 Hildesheim, Germany | Phone: +49-5121-206917-0    |
> Amtsgericht Hildesheim, HRA 2686           | Fax:   +49-5121-206917-5555 |
