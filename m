Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754495Ab1G0PmH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 11:42:07 -0400
Received: from mga09.intel.com ([134.134.136.24]:26610 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752784Ab1G0PmF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 11:42:05 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,276,1309762800"; 
   d="scan'208";a="30746658"
Date: Wed, 27 Jul 2011 08:42:03 -0700
From: Andi Kleen <ak@linux.intel.com>
To: Boris Ostrovsky <boris.ostrovsky@amd.com>
Cc: Andi Kleen <andi@firstfloor.org>, "ostr@amd64.org" <ostr@amd64.org>,
        "jvpeetz@web.de" <jvpeetz@web.de>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] [25/98] x86, AMD: Fix APIC timer erratum 400 affecting
 K8 Rev.A-E processors
Message-ID: <20110727154203.GB16180@tassilo.jf.intel.com>
References: <20110726534.972201586@firstfloor.org>
 <20110727003517.6946C2403FF@tassilo.jf.intel.com>
 <4E3006DF.6010906@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E3006DF.6010906@amd.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Andi, this patch is unnecessary.
> 
> It (as well as 328935e6348c6a7cb34798a68c326f4b8372e68a and
> 14fb57dccb6e1defe9f89a66f548fcb24c374c1d) is superseded by
> e9cdd343a5e42c43bcda01e609fa23089e026470 upstream

Is it obsolete in 2.6.35 too?

So what should I do? Drop this one and merge some other?
Or just drop?

If yes why do the other ones not have Cc: stable marks?

Thanks,

-Andi
