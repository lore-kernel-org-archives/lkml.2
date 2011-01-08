Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752905Ab1AHBZg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Jan 2011 20:25:36 -0500
Received: from mga11.intel.com ([192.55.52.93]:23176 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752291Ab1AHBZf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Jan 2011 20:25:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,292,1291622400"; 
   d="scan'208";a="644691850"
Date: Sat, 8 Jan 2011 08:58:18 +0800
From: Yong Wang <yong.y.wang@linux.intel.com>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: "Song, Youquan" <youquan.song@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "hpa@linux.intel.com" <hpa@linux.intel.com>, yong.y.wang@intel.com,
        "joe@perches.com" <joe@perches.com>,
        "jbaron@redhat.com" <jbaron@redhat.com>,
        "arjan@linux.intel.com" <arjan@linux.intel.com>,
        "trenn@suse.de" <trenn@suse.de>, "Liu, Kent" <kent.liu@intel.com>,
        "Guo, Chaohong" <chaohong.guo@intel.com>,
        Youquan Song <youquan.song@linux.intel.com>
Subject: Re: [PATCH v2 1/2] apic: Fix error interrupt report at all APs
Message-ID: <20110108005818.GA8502@ywang-moblin2.bj.intel.com>
References: <1294418204-15587-1-git-send-email-youquan.song@intel.com> <1294418204-15587-2-git-send-email-youquan.song@intel.com> <1294425713.2673.18.camel@sbsiddha-MOBL3.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294425713.2673.18.camel@sbsiddha-MOBL3.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > --- a/arch/x86/include/asm/apicdef.h
> > +++ b/arch/x86/include/asm/apicdef.h
> > @@ -78,6 +78,7 @@
> >  #define		APIC_DEST_LOGICAL	0x00800
> >  #define		APIC_DEST_PHYSICAL	0x00000
> >  #define		APIC_DM_FIXED		0x00000
> > +#define		APIC_DM_FIXED_MASK	0x00700
> 
> It should be called APIC_DM_MASK. Other than that this patch looks good.
> 

Right, since every delivery mode uses the same mask. 
Acked-by: Yong Wang <yong.y.wang@intel.com>

-Yong

