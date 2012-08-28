Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096Ab2H1RQZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 13:16:25 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:50839 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751676Ab2H1RQY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 13:16:24 -0400
Date: Tue, 28 Aug 2012 10:16:19 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Joonyoung Shim <jy0922.shim@samsung.com>
Cc: linux-kernel@vger.kernel.org, kyungmin.park@samsung.com,
        yadi.brar@samsung.com, jonghwa3.lee@samsung.com
Subject: Re: [PATCH] regulator: max77686: add of_node assignment
Message-ID: <20120828171618.GF4534@opensource.wolfsonmicro.com>
References: <1346153130-29038-1-git-send-email-jy0922.shim@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346153130-29038-1-git-send-email-jy0922.shim@samsung.com>
X-Cookie: Today is what happened to yesterday.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 28, 2012 at 08:25:30PM +0900, Joonyoung Shim wrote:
> Consumer nodes can reference regulators using <name>-supply from dts
> file with this patch.
> 
> Signed-off-by: Joonyoung Shim <jy0922.shim@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>

This doesn't apply against current code, the changes already appear to
be there...
