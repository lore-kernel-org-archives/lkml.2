Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758053Ab1BKUDc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Feb 2011 15:03:32 -0500
Received: from mga02.intel.com ([134.134.136.20]:56021 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756989Ab1BKUDc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Feb 2011 15:03:32 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.60,457,1291622400"; 
   d="scan'208";a="706781875"
Subject: Re: [Patch] idle governor: Avoid lock acquisition to read pm_qos
 before entering idle
From: Tim Chen <tim.c.chen@linux.intel.com>
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, mark gross <markgross@thegnar.org>,
        David Alan Gilbert <linux@treblig.org>, linux-kernel@vger.kernel.org,
        Len <len.brown@intel.com>, Andi Kleen <ak@linux.intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>, Len Brown <lenb@kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>
In-Reply-To: <1297452814.4967.110.camel@mulgrave.site>
References: <1297300864.2645.128.camel@schen9-DESK>
	 <201102110017.16066.rjw@sisk.pl> <1297385416.2645.262.camel@schen9-DESK>
	 <201102112022.25637.rjw@sisk.pl>  <1297452478.2645.265.camel@schen9-DESK>
	 <1297452814.4967.110.camel@mulgrave.site>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 11 Feb 2011 12:03:50 -0800
Message-ID: <1297454630.2645.277.camel@schen9-DESK>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 (2.28.3-1.fc12) 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-02-11 at 13:33 -0600, James Bottomley wrote:
> On Fri, 2011-02-11 at 11:27 -0800, Tim Chen wrote:
> > On Fri, 2011-02-11 at 20:22 +0100, Rafael J. Wysocki wrote:
> > 
> > > 
> > > Thanks, but I'd put that comment before the structure definition with the
> > > "NOTE:" prefix and I think you should explain the reason why that field
> > > shouldn't be changed to 64-bits.
> > > 
> > 
> > Either you or James want to suggest a comment on why the field shouldn't
> > be changed to 64-bits to be placed there?
> 
> /*
>  * Note: The lockless read read path depends on the CPU accessing 
>  * target_value atomically.  Atomic access is only guaranteed on all CPU
>  * types linux supports for 32 bit quantites
>  */
> 
> James
> 
> 

Thanks.  I will incorporate your suggested comment in an updated patch.

Tim


