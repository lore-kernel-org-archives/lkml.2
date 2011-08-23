Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1HWLPt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 07:15:49 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:60906 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752225Ab1HWLPm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 07:15:42 -0400
Date: Tue, 23 Aug 2011 12:15:33 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Catalin Marinas <catalin.marinas@arm.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v7 03/16] ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead
	of PGDIR_*
Message-ID: <20110823111533.GH19622@n2100.arm.linux.org.uk>
References: <1312988619-16804-1-git-send-email-catalin.marinas@arm.com> <1312988619-16804-4-git-send-email-catalin.marinas@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1312988619-16804-4-git-send-email-catalin.marinas@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Aug 10, 2011 at 04:03:26PM +0100, Catalin Marinas wrote:
> @@ -183,7 +183,7 @@ static int __init consistent_init(void)
>  		}
>  
>  		consistent_pte[i++] = pte;
> -		base += (1 << PGDIR_SHIFT);
> +		base += (1 << PMD_SHIFT);

Please replace with PMD_SIZE.

Once combined with the "fixup! ARM: LPAE: Use PMD_(SHIFT|SIZE|MASK) instead of PGDIR_*"
patch (and once whatever "fixup!" is done) this can be submitted to the
patch system.
