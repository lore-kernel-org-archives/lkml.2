Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755718Ab2HTHwg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Aug 2012 03:52:36 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59727 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755631Ab2HTHwe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Aug 2012 03:52:34 -0400
Date: Mon, 20 Aug 2012 15:52:50 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Jonathan Cameron <jic23@jic23.retrosnub.co.uk>
Cc: Marek Vasut <marex@denx.de>, linux-kernel@vger.kernel.org,
        linux-iio@vger.kernel.org, Jonathan Cameron <jic23@kernel.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: Re: [PATCH 3/3] IIO: arm: Add LRADC to i.MX28 dts
Message-ID: <20120820075249.GJ24242@S2101-09.ap.freescale.net>
References: <1344784918-32352-1-git-send-email-marex@denx.de>
 <201208170457.03686.marex@denx.de>
 <CAAQ0ZWROobdtFkzn9Sr7v5B29zYTQ5YEUZV59kkNE_yv6qbmgQ@mail.gmail.com>
 <201208191730.31969.marex@denx.de>
 <5031E753.5070200@jic23.retrosnub.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5031E753.5070200@jic23.retrosnub.co.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 20, 2012 at 08:29:23AM +0100, Jonathan Cameron wrote:
> Mostly these prefixes are an excuse for grumpy maintainers to moan
> at people :)

Yeah, I have to become grumpy when my comment gets ignored and I have
to make it right (for several times) to avoid my upstream moaning at me.

Is it so hard?  You are not creating a new subsystem but just patching
an existing file.  A "git log" on the file simply shows you how to do it.

-- 
Regards,
Shawn
