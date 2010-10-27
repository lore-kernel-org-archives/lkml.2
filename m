Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759721Ab0J0JBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Oct 2010 05:01:34 -0400
Received: from one.firstfloor.org ([213.235.205.2]:34778 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754436Ab0J0JBd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Oct 2010 05:01:33 -0400
Date: Wed, 27 Oct 2010 11:01:29 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Andi Kleen <andi@firstfloor.org>, torvalds@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        n-horiguchi@ah.jp.nec.com, x86@kernel.org
Subject: Re: [GIT PULL] Please pull hwpoison updates for 2.6.37
Message-ID: <20101027090128.GC2472@basil.fritz.box>
References: <20101026100923.GA5118@basil.fritz.box>
 <20101027074254.GA809@elte.hu>
 <20101027075846.GA2472@basil.fritz.box>
 <20101027081853.GA20196@elte.hu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101027081853.GA20196@elte.hu>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> You are welcome! How about the cleanliness feedback that i gave?
> (the stuff in parentheses)

Could move the ifdef into mm.h for the flags and let the optimizer
eliminate the code. I can do that in a followup patch.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
