Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758796Ab1FVTLt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 15:11:49 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38971 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758056Ab1FVTLs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 15:11:48 -0400
Date: Wed, 22 Jun 2011 20:11:46 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org,
        Dimitris Papastamos <dp@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Liam Girdwood <lrg@ti.com>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110622191145.GA19628@opensource.wolfsonmicro.com>
References: <20110622184407.GC13847@sirena.org.uk>
 <1308768353-19372-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <4E023C72.3030109@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E023C72.3030109@metafoo.de>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 09:03:14PM +0200, Lars-Peter Clausen wrote:
> On 06/22/2011 08:45 PM, Mark Brown wrote:

> > +	if (map->bus->read_flag_bit)
> > +		u8[0] |= 1 << map->bus->read_flag_bit;

> Should be 1 << (map->bus->read_flag_bit - 1)

The code has the sematic I intended; you can debate if it's the best
semantic and looking at the documentation again it's not entirely clear
so at least that should be updated.
