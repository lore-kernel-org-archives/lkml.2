Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755972Ab2HAUHb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Aug 2012 16:07:31 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:39311 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752452Ab2HAUH3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Aug 2012 16:07:29 -0400
Date: Wed, 1 Aug 2012 21:07:27 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paul.liu@linaro.org>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: anatop: Fix wrong mask used in
 anatop_get_voltage_sel
Message-ID: <20120801200727.GT4483@opensource.wolfsonmicro.com>
References: <1342455042.25850.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342455042.25850.1.camel@phoenix>
X-Cookie: Don't feed the bats tonight.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 12:10:42AM +0800, Axel Lin wrote:
> The mask used in anatop_get_voltage_sel does not match the mask used in
> anatop_set_voltage_sel.
> We need to do left shift anatop_reg->vol_bit_shift bits for the correct mask.

Applied, thanks.
