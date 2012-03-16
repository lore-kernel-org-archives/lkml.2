Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755839Ab2CPTLb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Mar 2012 15:11:31 -0400
Received: from relay1.sgi.com ([192.48.179.29]:56935 "EHLO relay.sgi.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754687Ab2CPTLa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Mar 2012 15:11:30 -0400
Date: Fri, 16 Mar 2012 14:11:28 -0500
From: Robin Holt <holt@sgi.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        holt@sgi.com
Subject: Re: [PATCH 02/11] sgi-xp: Use lockdep_assert_held
Message-ID: <20120316191128.GH4958@sgi.com>
References: <1331924464-18023-1-git-send-email-andi@firstfloor.org>
 <1331924464-18023-3-git-send-email-andi@firstfloor.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331924464-18023-3-git-send-email-andi@firstfloor.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 16, 2012 at 12:00:55PM -0700, Andi Kleen wrote:
> From: Andi Kleen <ak@linux.intel.com>
> 
> !spin_is_locked() is always true on a up build, so cannot
> be used for assert.  Replace with lockdep_assert_held.
> 
> I realize UP builds are not very likely for this driver,
> but it's still better to fix it.

Acked-by: Robin Holt <holt@sgi.com>
