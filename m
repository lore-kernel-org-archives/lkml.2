Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932672Ab1JXNqg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Oct 2011 09:46:36 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:49178 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932478Ab1JXNqf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Oct 2011 09:46:35 -0400
Date: Mon, 24 Oct 2011 15:46:32 +0200
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: jhbird.choi@gmail.com
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Liam Girdwood <lrg@ti.com>,
        Haojian Zhuang <haojian.zhuang@marvell.com>
Subject: Re: [PATCH v2] regulator: max8649 Convert max8649 to use regmap api
Message-ID: <20111024134632.GC26033@opensource.wolfsonmicro.com>
References: <1319462786-2602-1-git-send-email-jhbird.choi@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1319462786-2602-1-git-send-email-jhbird.choi@gmail.com>
X-Cookie: If you can read this, you're too close.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 24, 2011 at 10:26:26PM +0900, jhbird.choi@gmail.com wrote:
> From: Jonghwan Choi <jhbird.choi@gmail.com>
> 
> Signed-off-by: Jonghwan Choi <jhbird.choi@gmail.com>

Looks good!

Acked-by: Mark Brown <broonie@opensource.wolfsonmicro.com>

Once the merge window is over it might be useful to look at enabling
register cache for the driver, you'll get a performance improvement as
it'll be able to skip the read part of read/modify/write cycles.
