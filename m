Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751440Ab1GTIFO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jul 2011 04:05:14 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:52673 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751080Ab1GTIFM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jul 2011 04:05:12 -0400
Date: Wed, 20 Jul 2011 09:04:41 +0100
From: Russell King <rmk@arm.linux.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Kukjin Kim <kgene.kim@samsung.com>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jaecheol Lee <jc.lee@samsung.com>
Subject: Re: linux-next: manual merge of the s5p tree with the arm tree
Message-ID: <20110720080441.GA28730@flint.arm.linux.org.uk>
References: <20110720113558.1fb8c2f8392f52c77becf46a@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110720113558.1fb8c2f8392f52c77becf46a@canb.auug.org.au>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 20, 2011 at 11:35:58AM +1000, Stephen Rothwell wrote:
> BTW, Russell, commit 29cb3cd208dd above changed the return type of
> exynos4_cpu_suspend() from void to int but did not add any return
> statement ...

That's fine - it ends with a call to panic() which is declared as a
function which never returns.  Therefore, exynos4_cpu_suspend() itself
never returns.

-- 
Russell King
 Linux kernel    2.6 ARM Linux   - http://www.arm.linux.org.uk/
 maintainer of:
