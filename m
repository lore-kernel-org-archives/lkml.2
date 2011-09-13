Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754899Ab1IMPOd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 11:14:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:52554 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753256Ab1IMPOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 11:14:33 -0400
Date: Tue, 13 Sep 2011 16:14:20 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christian Pellegrin <chripell@evolware.org>,
        Ben Dooks <ben@simtec.co.uk>, Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH] ASoC: samsung: Fix checking return value of clk_get
Message-ID: <20110913151420.GA23782@opensource.wolfsonmicro.com>
References: <1315925062.6042.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315925062.6042.1.camel@phoenix>
X-Cookie: Are you a turtle?
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 13, 2011 at 10:44:22PM +0800, Axel Lin wrote:
> clk_get() returns a pointer to the struct clk or an ERR_PTR().

Are you sure that the Samsung clock implementation actually does this?
