Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758Ab2FJX1h (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 19:27:37 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:36584 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753308Ab2FJX1g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 19:27:36 -0400
MIME-Version: 1.0
Reply-To: axel.lin@gmail.com
In-Reply-To: <877gvfvxyd.fsf@free.fr>
References: <1339115141.4310.3.camel@phoenix> <1339115204.4310.4.camel@phoenix>
 <877gvfvxyd.fsf@free.fr>
From: Axel Lin <axel.lin@gmail.com>
Date: Mon, 11 Jun 2012 07:27:15 +0800
Message-ID: <CAF+7xWm_C5tZaXPsH3944_f-h4vuvRb1MorPuTB0fWTVhT9RPA@mail.gmail.com>
Subject: Re: [PATCH RFT 2/2] regulator: max1586: Convert max1586_v3_ops to
 set_voltage_sel and map_voltage_linear
To: Robert Jarzmik <robert.jarzmik@free.fr>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/6/11 Robert Jarzmik <robert.jarzmik@free.fr>:
> Axel Lin <axel.lin@gmail.com> writes:
>
>> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> Hi Axel,
>
> The patches look OK to me, but I cannot build them.
> Even on top of linux-next, I get :
> drivers/regulator/max1586.c: In function 'max1586_v6_set_voltage_sel':
> drivers/regulator/max1586.c:86:2: error: 'const struct regulator_desc' has no member named 'volt_table'
> drivers/regulator/max1586.c: At top level:
> drivers/regulator/max1586.c:105:18: error: 'regulator_list_voltage_table' undeclared here (not in a function)
> drivers/regulator/max1586.c:123:3: error: unknown field 'volt_table' specified in initializer
> drivers/regulator/max1586.c:123:3: warning: initialization from incompatible pointer type [enabled by default]
> drivers/regulator/max1586.c:123:3: warning: (near initialization for 'max1586_reg[1].ops') [enabled by default]
>
> I suppose you're basing your tree on top of a set of commits not available in
> linux-next (maybe Mark's regulator tree ?). As I don't have that tree in mind,
> it would be kind to tell me which tree you're basing your work on, so that I
> could test your last patches.

I think all the necessary patches are already in linux-next tree.
I have no problem to build it with linux-next 20120608.

Regards,
Axel
