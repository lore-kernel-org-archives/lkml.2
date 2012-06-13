Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754790Ab2FMVjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Jun 2012 17:39:16 -0400
Received: from mga11.intel.com ([192.55.52.93]:36669 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753229Ab2FMVjP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Jun 2012 17:39:15 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="165328272"
Date: Wed, 13 Jun 2012 14:39:15 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Andi Kleen <andi@firstfloor.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, eranian@google.com
Subject: Re: [PATCH 2/4] x86: Track minimum microcode revision globally v2
Message-ID: <20120613213915.GE32604@tassilo.jf.intel.com>
References: <1339618842-26636-1-git-send-email-andi@firstfloor.org>
 <1339618842-26636-3-git-send-email-andi@firstfloor.org>
 <1339623261.8980.65.camel@twins>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1339623261.8980.65.camel@twins>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 13, 2012 at 11:34:21PM +0200, Peter Zijlstra wrote:
> On Wed, 2012-06-13 at 13:20 -0700, Andi Kleen wrote:
> > +       for_each_online_cpu (i)
> 
> # git grep "for_each_[^(]*(" arch/x86/ | wc -l
> 315
> # git grep "for_each_[^(]* (" arch/x86/ | wc -l
> 0

Well, it's a for loop. Do you want me to grep for all for loops.
We've never written for loops without space. Loops without space
do not make any sense to me.

Anyways I'm changing it but under protest. 

-Andi
-- 
ak@linux.intel.com -- Speaking for myself only
