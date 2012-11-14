Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932360Ab2KNBOy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 20:14:54 -0500
Received: from mga02.intel.com ([134.134.136.20]:36363 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932291Ab2KNBOw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 20:14:52 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.83,247,1352102400"; 
   d="scan'208";a="219270704"
Date: Tue, 13 Nov 2012 17:14:50 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Arjan van de Ven <arjan@linux.intel.com>
Cc: paulmck@linux.vnet.ibm.com, Linux PM <linux-pm@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121113171450.3657290c@chromoly>
In-Reply-To: <50A2E116.8000400@linux.intel.com>
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
	<20121113211602.GA30150@linux.vnet.ibm.com>
	<20121113133922.47144a50@chromoly>
	<20121113222350.GH2489@linux.vnet.ibm.com>
	<50A2CD77.7000403@linux.intel.com>
	<20121114000259.GK2489@linux.vnet.ibm.com>
	<50A2E116.8000400@linux.intel.com>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 13 Nov 2012 16:08:54 -0800
Arjan van de Ven <arjan@linux.intel.com> wrote:

> > I think I know, but I feel the need to ask anyway.  Why not tell
> > RCU about the clamping?  
> 
> I don't mind telling RCU, but what cannot happen is a bunch of CPU
> time suddenly getting used (since that is the opposite of what is
> needed at the specific point in time of going idle)
Another reason is my observation that there are some assumptions/checks
to make sure only idle thread can tell rcu it is idle. Is it ok to
extend that to other kthreads?

-- 
Thanks,

Jacob
