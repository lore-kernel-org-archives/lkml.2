Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759914Ab2IEXxV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 19:53:21 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:56157 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755182Ab2IEXxU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 19:53:20 -0400
Date: Thu, 6 Sep 2012 07:53:15 +0800
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Kim, Milo" <Milo.Kim@ti.com>
Cc: "Girdwood, Liam" <lrg@ti.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/5] regulator: lp872x: remove platform data dependency
Message-ID: <20120905235314.GL10580@opensource.wolfsonmicro.com>
References: <A874F61F95741C4A9BA573A70FE3998F41EF21B9@DQHE02.ent.ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <A874F61F95741C4A9BA573A70FE3998F41EF21B9@DQHE02.ent.ti.com>
X-Cookie: Bridge ahead.  Pay troll.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 05, 2012 at 04:38:40AM +0000, Kim, Milo wrote:
> This patch-set removes the platform data dependency.
> The LP872x driver should be run even if the platform data is not defined.

Applied all, thanks.
