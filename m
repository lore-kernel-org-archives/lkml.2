Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754529Ab1FUMHW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jun 2011 08:07:22 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:37752 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752832Ab1FUMHS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jun 2011 08:07:18 -0400
Date: Tue, 21 Jun 2011 13:07:16 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Dimitris Papastamos <dp@opensource.wolfsonmicro.com>
Cc: linux-kernel@vger.kernel.org, Liam Girdwood <lrg@ti.com>,
        Samuel Oritz <sameo@linux.intel.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        Graeme Gregory <gg@slimlogic.co.uk>
Subject: Re: [PATCH 1/8] regmap: Add generic non-memory mapped register
 access API
Message-ID: <20110621120716.GB24543@opensource.wolfsonmicro.com>
References: <20110620124608.GB31140@opensource.wolfsonmicro.com>
 <1308574489-31322-1-git-send-email-broonie@opensource.wolfsonmicro.com>
 <20110621114347.GA11422@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110621114347.GA11422@opensource.wolfsonmicro.com>
X-Cookie: You now have Asian Flu.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 21, 2011 at 12:43:47PM +0100, Dimitris Papastamos wrote:
> On Mon, Jun 20, 2011 at 01:54:42PM +0100, Mark Brown wrote:

> > +static int _regmap_raw_write(struct regmap *map, unsigned int reg,
> > +			     const void *val, size_t val_len)
> > +{
> > +	void *buf;
> > +	int ret = -ENOTSUPP;
> > +	int len;

> size_t for len?

Yes.
