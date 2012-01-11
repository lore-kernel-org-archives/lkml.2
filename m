Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757316Ab2AKJVO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jan 2012 04:21:14 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:35998 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756616Ab2AKJVJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jan 2012 04:21:09 -0500
Date: Wed, 11 Jan 2012 09:20:53 +0000
From: Catalin Marinas <catalin.marinas@arm.com>
To: Tiejun Chen <tiejun.chen@windriver.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/1] kmemleak: only scan non-zero-size section
Message-ID: <20120111092052.GA858@arm.com>
References: <1326261070-24427-1-git-send-email-tiejun.chen@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1326261070-24427-1-git-send-email-tiejun.chen@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 11, 2012 at 05:51:10AM +0000, Tiejun Chen wrote:
> We should only scan that invalid section which size is not
> zero as well.
> 
> Signed-off-by: Tiejun Chen <tiejun.chen@windriver.com>

Looks good. I'll merge it in my kmemleak branch (and send it to Linus at
some point).

Thanks.

-- 
Catalin
