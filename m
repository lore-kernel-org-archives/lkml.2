Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933010Ab1JZMwq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Oct 2011 08:52:46 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36717 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932967Ab1JZMwp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Oct 2011 08:52:45 -0400
Date: Wed, 26 Oct 2011 13:52:44 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Marcus Folkesson <marcus.folkesson@gmail.com>
Cc: jhbird.choi@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regulator: Use regmap_read/write(), regmap_update_bits
	functions directly
Message-ID: <20111026125244.GB29548@opensource.wolfsonmicro.com>
References: <CAM8FrKKPjvmtqo2v_xjQBw+xBoBypynp_YdwkXThm=EVyU2y9Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM8FrKKPjvmtqo2v_xjQBw+xBoBypynp_YdwkXThm=EVyU2y9Q@mail.gmail.com>
X-Cookie: Be different: conform.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 26, 2011 at 01:14:00PM +0200, Marcus Folkesson wrote:
> Is'nt this change already made in commit
> 90923351d480fffd0d24646db83f6f8315eed0d9 ?

> Are you using an old kernel version?

This is building on that patch - the original patch had the regmap
calls within the bodies of the original driver specific read/write
fuctions.  This removes the original read/write functions and makes the
call sites use regmap directly.
