Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751563Ab2LJDMi (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Dec 2012 22:12:38 -0500
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56234 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750821Ab2LJDMh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Dec 2012 22:12:37 -0500
Date: Mon, 10 Dec 2012 12:12:31 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Nancy Chen <Nancy.Chen@freescale.com>,
        "Ying-Chun Liu (PaulLiu)" <paulliu@debian.org>,
        Liam Girdwood <lrg@ti.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH RFT 1/2] regulator: anatop: Use linear_min_sel with
 linear mapping
Message-ID: <20121210031230.GB10927@opensource.wolfsonmicro.com>
References: <1355011545.3283.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1355011545.3283.1.camel@phoenix>
X-Cookie: Many pages make a thick book.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 09, 2012 at 08:05:45AM +0800, Axel Lin wrote:
> By setting linear_min_sel to anatop_reg->min_bit_val, we can avoid
> adjust the anatop_reg->min_bit_val offset in [set|get]_voltage_sel.

Applied both, thanks.
