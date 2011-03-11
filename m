Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754527Ab1CKLIs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Mar 2011 06:08:48 -0500
Received: from mail-qy0-f181.google.com ([209.85.216.181]:49849 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753463Ab1CKLIq convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Mar 2011 06:08:46 -0500
MIME-Version: 1.0
In-Reply-To: <20110310155341.GA27206@opensource.wolfsonmicro.com>
References: <1299764621-2532-1-git-send-email-linus.walleij@stericsson.com>
	<20110310134953.GE22195@opensource.wolfsonmicro.com>
	<AANLkTim5Qw_PQJ234YsNvvmsg7L-RGfTsuMaTHvUmLHK@mail.gmail.com>
	<20110310155341.GA27206@opensource.wolfsonmicro.com>
Date: Fri, 11 Mar 2011 12:08:45 +0100
Message-ID: <AANLkTi=wv-HM3CVrfE-akwhpbV061LMKMQoxbsrRzRa6@mail.gmail.com>
Subject: Re: [PATCH 2/4] regulator: add ab8500 per-regulator startup delay
From: Linus Walleij <linus.walleij@linaro.org>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: Linus Walleij <linus.walleij@stericsson.com>,
        Liam Girdwood <lrg@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        Lee Jones <lee.jones@linaro.org>,
        Bengt Jonsson <bengt.g.jonsson@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 10, 2011 at 4:53 PM, Mark Brown
<broonie@opensource.wolfsonmicro.com> wrote:
> On Thu, Mar 10, 2011 at 04:43:50PM +0100, Linus Walleij wrote:
>> as well. disable() may look superfluous but I bet there may be
>> cases where not having a voltage fully disabled before doing
>> something will cause immesurable harm.
>
> Given how heavily dependant collapsing the voltage is on the external
> circuitry I'm not sure the driver can say too much useful here.  Usually
> you're either going to collapse very quickly due to active discharge and
> load or you're heavily dependant on the board.

Hm! That's true. So if needed this should probably be a delay setting in
the rail in the struct regulation_constraints if it's really needed?

(I'll verify if it's need before implementing that.)

Linus Walleij
