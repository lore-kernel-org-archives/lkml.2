Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935511Ab1IOXuH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 19:50:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42564 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S935471Ab1IOXuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 19:50:05 -0400
Date: Fri, 16 Sep 2011 00:50:02 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Axel Lin <axel.lin@gmail.com>
Cc: linux-kernel@vger.kernel.org, Christian Pellegrin <chripell@evolware.org>,
        Ben Dooks <ben@simtec.co.uk>, Jassi Brar <jassisinghbrar@gmail.com>,
        Sangbeom Kim <sbkim73@samsung.com>, Liam Girdwood <lrg@ti.com>,
        alsa-devel@alsa-project.org
Subject: Re: [PATCH v2] ASoC: samsung: Fix checking return value of clk_get
Message-ID: <20110915235002.GB4403@opensource.wolfsonmicro.com>
References: <1316054214.3496.1.camel@phoenix>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316054214.3496.1.camel@phoenix>
X-Cookie: Slow day.  Practice crawling.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 15, 2011 at 10:36:54AM +0800, Axel Lin wrote:
> clk_get() returns a pointer to the struct clk or an ERR_PTR().
> This patch also use PTR_ERR() for return value.

Applied, thanks.
