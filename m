Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753975Ab1GVKro (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Jul 2011 06:47:44 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:50543 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751191Ab1GVKrj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Jul 2011 06:47:39 -0400
Subject: Re: [PATCH] regulator: tps65910: Fix array access out of bounds bug
From: Liam Girdwood <lrg@kernel.org>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Graeme Gregory <gg@slimlogic.co.uk>,
        Jorge Eduardo Candelaria <jedu@slimlogic.co.uk>,
        Liam Girdwood <lrg@ti.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1310349463.2316.4.camel@phoenix>
References: <1310349463.2316.4.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 22 Jul 2011 11:47:27 +0100
Message-ID: <1311331647.3312.9.camel@odin>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-11 at 09:57 +0800, Axel Lin wrote:
> For tps65910, the number of regulator is 13. ( ARRAY_SIZE(tps65910_regs) is 13)
> For tps65911, the number of regulator is 12. ( ARRAY_SIZE(tps65911_regs) is 12)
> If we are using this driver for tps65911,
> we hit array access out of bounds bug in tps65910_probe() because
> current implementation always assume the number of regulator is 13 and
> thus it will access tps65911_regs[12].
> 
> Fix it by setting correct num_regulators for both chips in tps65910_probe(),
> and allocated neccessay memory accordingly.
> 
> Signed-off-by: Axel Lin <axel.lin@gmail.com>


Applied.

Thanks

Liam

