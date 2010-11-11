Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756572Ab0KKTtl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Nov 2010 14:49:41 -0500
Received: from one.firstfloor.org ([213.235.205.2]:56771 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756540Ab0KKTti (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Nov 2010 14:49:38 -0500
Date: Thu, 11 Nov 2010 20:49:36 +0100
From: Andi Kleen <andi@firstfloor.org>
To: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Andi Kleen <ak@linux.intel.com>, Andi Kleen <andi@firstfloor.org>,
        linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        a.p.zijlstra@chello.nl, mingo@elte.hu, acme@redhat.com,
        eranian@google.com
Subject: Re: [PATCH 2/3] perf: Add support for extra parameters for raw
 events
Message-ID: <20101111194936.GJ18718@basil.fritz.box>
References: <1289492117-18066-1-git-send-email-andi@firstfloor.org>
 <1289492117-18066-2-git-send-email-andi@firstfloor.org>
 <4CDC2DDD.50508@linux.vnet.ibm.com>
 <4CDC3845.4030104@linux.intel.com>
 <4CDC4628.8020109@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CDC4628.8020109@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I think it would have parsed OK, but it is a confusing syntax to
> look at.  I should point out that there are also the u,k,h modifiers
> which can be specified, even on raw events, so the full syntax looks
> something like:
> 
> -e rXXXX[+YYYY][:u|:k|:h]

Ok I can fix the help text for that.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
