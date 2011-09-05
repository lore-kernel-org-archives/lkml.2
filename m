Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752768Ab1IEWA0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Sep 2011 18:00:26 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42521 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751867Ab1IEWAS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Sep 2011 18:00:18 -0400
Date: Mon, 5 Sep 2011 15:00:14 -0700
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Lars-Peter Clausen <lars@metafoo.de>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: Make debugfs stubs static inline
Message-ID: <20110905220014.GD11107@opensource.wolfsonmicro.com>
References: <1315253173-9600-1-git-send-email-lars@metafoo.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1315253173-9600-1-git-send-email-lars@metafoo.de>
X-Cookie: You will wish you hadn't.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 05, 2011 at 10:06:13PM +0200, Lars-Peter Clausen wrote:
> Make the debugfs stubs static inline to avoid future compilation issues due to
> duplicated symbols when CONFIG_DEBUG_FS=n once internal.h is included by
> multiple source files.

Applied, thanks.
