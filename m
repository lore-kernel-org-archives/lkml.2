Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753695Ab2KMGzR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:55:17 -0500
Received: from mga03.intel.com ([143.182.124.21]:58313 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752500Ab2KMGzM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:55:12 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.80,764,1344236400"; 
   d="scan'208";a="216954857"
Date: Mon, 12 Nov 2012 22:55:02 -0800
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Joe Perches <joe@perches.com>
Cc: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Zhang Rui <rui.zhang@intel.com>, Rob Landley <rob@landley.net>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>
Subject: Re: [PATCH 3/3] PM: Introduce Intel PowerClamp Driver
Message-ID: <20121112225502.17421024@chromoly>
In-Reply-To: <1352788416.24230.6.camel@joe-AO722>
References: <1352757831-5202-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1352757831-5202-4-git-send-email-jacob.jun.pan@linux.intel.com>
	<1352788416.24230.6.camel@joe-AO722>
Organization: OTC
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 12 Nov 2012 22:33:36 -0800
Joe Perches <joe@perches.com> wrote:

> > Intel PowerClamp driver performs synchronized idle injection across
> > all online CPUs. The goal is to maintain a given package level
> > C-state ratio.  
> 
> style trivia:
they are all good catches. will fix in the next version.

-- 
Thanks,

Jacob
