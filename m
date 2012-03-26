Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756504Ab2CZIwn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 04:52:43 -0400
Received: from mga02.intel.com ([134.134.136.20]:20550 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755830Ab2CZIwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 04:52:41 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="125106549"
Date: Mon, 26 Mar 2012 11:00:55 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Arun MURTHY <arun.murthy@stericsson.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Anton Vorontsov <avorontsov@ru.mvista.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: build failure after merge of the battery tree
Message-ID: <20120326090055.GC20638@sortiz-mobl>
References: <20120315135609.2f9a2a030866c476dc736b9c@canb.auug.org.au>
 <20120320153912.b97107ca4128d0692de17799@canb.auug.org.au>
 <20120326131316.b791ebefd94d8cbcac5bccfa@canb.auug.org.au>
 <F45880696056844FA6A73F415B568C6958BEEDDB7F@EXDCVYMBSTM006.EQ1STM.local>
 <CACRpkdY2SrRNhQKTH1V_MJ2ZoLMnOD8-=Qfzc3XeXBHZk-dUUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdY2SrRNhQKTH1V_MJ2ZoLMnOD8-=Qfzc3XeXBHZk-dUUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 26, 2012 at 08:55:37AM +0200, Linus Walleij wrote:
> On Mon, Mar 26, 2012 at 4:31 AM, Arun MURTHY <arun.murthy@stericsson.com> wrote:
> 
> > There is a dependency with MFD tree. Please pull the MFD tree along with
> > these patches to overcome the build errors.
> 
> Maybe the problem is that the needed MFD changes have not reached
> the MFD for-next branch? (To me that looks like the actual issue.)
Which changes are missing from for-next ?

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
