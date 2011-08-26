Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1HZXr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Aug 2011 19:47:56 -0400
Received: from mga11.intel.com ([192.55.52.93]:53094 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752920Ab1HZXrz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Aug 2011 19:47:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.68,287,1312182000"; 
   d="scan'208";a="45241117"
Subject: Re: MTRR setup failure on Fujitsu Lifebook S761
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Tony Vroon <tony@linx.net>, LKML <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Tejun Heo <tj@kernel.org>, "yinghai@kernel.org" <yinghai@kernel.org>,
        venki@google.com
Date: Fri, 26 Aug 2011 16:51:07 -0700
In-Reply-To: <4E581D1A.90404@zytor.com>
References: <4E579397.6010009@linx.net>  <4E57CBBB.3040806@zytor.com>
	 <1314385315.8356.0.camel@localhost>
	 <1314394157.4729.23.camel@sbsiddha-desk.sc.intel.com>
	 <4E581D1A.90404@zytor.com>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.1 (3.0.1-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1314402667.4729.38.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2011-08-26 at 15:24 -0700, H. Peter Anvin wrote:
> On 08/26/2011 02:29 PM, Suresh Siddha wrote:
> > On Fri, 2011-08-26 at 12:01 -0700, Tony Vroon wrote:
> >> On Fri, 2011-08-26 at 09:37 -0700, H. Peter Anvin wrote:
> >>> Hm, I don't see any evidence of the MTRR sanitizer running at all...
> >>
> >> It is almost as if it failed to find an optimal configuration; does that
> >> error path not print anything?
> > 
> > MTRR cleanup bails out in mtrr_need_cleanup() if it finds any entry
> > other than WB or UC. And the first entry you had was write-protect.
> 
> WP for the BIOS is becoming reasonably common; we need to handle that.

Agree. Ideally in this case PAT should have helped. There must be some
other hidden issue that I am trying to understand.

We should address the WP issue nevertheless.

thanks,
suresh

