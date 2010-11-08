Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753956Ab0KHAig (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 19:38:36 -0500
Received: from one.firstfloor.org ([213.235.205.2]:35078 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752517Ab0KHAif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 19:38:35 -0500
Date: Mon, 8 Nov 2010 01:38:31 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Cyrill Gorcunov <gorcunov@gmail.com>
Cc: Andi Kleen <andi@firstfloor.org>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, Andi Kleen <ak@linux.intel.com>,
        x86@kernel.org
Subject: Re: [PATCH] x86: fix apic.h unused but set warnings
Message-ID: <20101108003831.GF17592@basil.fritz.box>
References: <1289159606-17417-1-git-send-email-andi@firstfloor.org>
 <20101107212045.GC13175@lenovo>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101107212045.GC13175@lenovo>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  At least the former code _didn't_ hide the details of which
> part of 'long long' value we need. Would not
> 
>  u64 val;
>  rdmsrl(APIC_BASE_MSR + (reg >> 4), val);
>  return (u32)val;
> 
> be more clear?

Maybe, but I doubt it will make much difference either way.

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only.
