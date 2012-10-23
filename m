Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757131Ab2JWNbh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 09:31:37 -0400
Received: from one.firstfloor.org ([213.235.205.2]:59822 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753707Ab2JWNbg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 09:31:36 -0400
Date: Tue, 23 Oct 2012 15:31:36 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, eranian@google.com,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH 03/34] perf, x86: Basic Haswell PEBS support v2
Message-ID: <20121023133136.GY16230@one.firstfloor.org>
References: <1350602382-12771-1-git-send-email-andi@firstfloor.org> <1350602382-12771-4-git-send-email-andi@firstfloor.org> <1350993710.13456.8.camel@twins>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1350993710.13456.8.camel@twins>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Do things like the 0xd0 event really need all the UEVENT things spelled
> out?

There were some missing unit masks, so I spelled it out.

> And 0x22d0 (LOCK_STORES) still appears missing going by the pattern
> in there.

Will double check.


> Also, it looks like the 0xc5 things want to be UEVENT, the current EVENT
> thing will mask the umask.

Thanks.

-Andi
> 

-- 
ak@linux.intel.com -- Speaking for myself only.
