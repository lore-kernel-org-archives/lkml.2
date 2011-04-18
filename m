Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752536Ab1DRU5K (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Apr 2011 16:57:10 -0400
Received: from e6.ny.us.ibm.com ([32.97.182.146]:45109 "EHLO e6.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751949Ab1DRU5H (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Apr 2011 16:57:07 -0400
Subject: Re: [PATCH 1/2] break out page allocation warning code
From: Dave Hansen <dave@linux.vnet.ibm.com>
To: David Rientjes <rientjes@google.com>
Cc: linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        Johannes Weiner <hannes@cmpxchg.org>,
        Michal Nazarewicz <mina86@mina86.com>,
        Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <alpine.DEB.2.00.1104181321480.31186@chino.kir.corp.google.com>
References: <20110415170437.17E1AF36@kernel>
	 <alpine.DEB.2.00.1104161653220.14788@chino.kir.corp.google.com>
	 <1303139455.9615.2533.camel@nimitz>
	 <alpine.DEB.2.00.1104181321480.31186@chino.kir.corp.google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Date: Mon, 18 Apr 2011 13:57:01 -0700
Message-ID: <1303160221.9887.301.camel@nimitz>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-04-18 at 13:25 -0700, David Rientjes wrote:
> It shouldn't be a follow-on patch since you're introducing a new feature 
> here (vmalloc allocation failure warnings) and what I'm identifying is a 
> race in the access to current->comm.  A bug fix for a race should always 
> preceed a feature that touches the same code.

Dude.  Seriously.  Glass house!  a63d83f4

I'll go look in to it, though.

-- Dave

