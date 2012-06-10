Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754791Ab2FJSLt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Jun 2012 14:11:49 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:38047 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752836Ab2FJSLs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Jun 2012 14:11:48 -0400
From: Robert Jarzmik <robert.jarzmik@free.fr>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH RFT 2/2] regulator: max1586: Convert max1586_v3_ops to set_voltage_sel and map_voltage_linear
References: <1339115141.4310.3.camel@phoenix>
	<1339115204.4310.4.camel@phoenix>
X-URL: http://belgarath.falguerolles.org/
Date: Sun, 10 Jun 2012 20:11:38 +0200
In-Reply-To: <1339115204.4310.4.camel@phoenix> (Axel Lin's message of "Fri, 08
	Jun 2012 08:26:44 +0800")
Message-ID: <877gvfvxyd.fsf@free.fr>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Axel Lin <axel.lin@gmail.com> writes:

> Signed-off-by: Axel Lin <axel.lin@gmail.com>
Hi Axel,

The patches look OK to me, but I cannot build them.
Even on top of linux-next, I get :
drivers/regulator/max1586.c: In function 'max1586_v6_set_voltage_sel':
drivers/regulator/max1586.c:86:2: error: 'const struct regulator_desc' has no member named 'volt_table'
drivers/regulator/max1586.c: At top level:
drivers/regulator/max1586.c:105:18: error: 'regulator_list_voltage_table' undeclared here (not in a function)
drivers/regulator/max1586.c:123:3: error: unknown field 'volt_table' specified in initializer
drivers/regulator/max1586.c:123:3: warning: initialization from incompatible pointer type [enabled by default]
drivers/regulator/max1586.c:123:3: warning: (near initialization for 'max1586_reg[1].ops') [enabled by default]

I suppose you're basing your tree on top of a set of commits not available in
linux-next (maybe Mark's regulator tree ?). As I don't have that tree in mind,
it would be kind to tell me which tree you're basing your work on, so that I
could test your last patches.

Cheers.

--
Robert
