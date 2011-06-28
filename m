Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755762Ab1F1ADY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jun 2011 20:03:24 -0400
Received: from mga11.intel.com ([192.55.52.93]:9219 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab1F1ACT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jun 2011 20:02:19 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.65,435,1304319600"; 
   d="scan'208";a="21262359"
Subject: Re: power increase issue on light load
From: "Alex,Shi" <alex.shi@intel.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "ncrao@google.com" <ncrao@google.com>, "mingo@elte.hu" <mingo@elte.hu>,
        "Chen, Tim C" <tim.c.chen@intel.com>,
        "Li, Shaohua" <shaohua.li@intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        len.brown@intel.com
In-Reply-To: <1308876099.23204.124.camel@debian>
References: <1308797024.23204.95.camel@debian>
	 <1308819748.1022.69.camel@twins>  <1308876099.23204.124.camel@debian>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 28 Jun 2011 08:02:09 +0800
Message-ID: <1309219329.14604.11.camel@debian>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> > 
> > What happens if you try something like the below. Increased imbalance
> > might lead to more load-balance action, which might lead to more task
> > migration/waking up of cpus etc.
> > 
> > If the below makes any difference, Nikhil's changes have a funny that
> > needs to be caught.
> 
> Yes, it most remove the commit effect, So the power recovered. 
> 
> In fact the only suspicious I found is large imbalance, but that is
> the commit want ...

Any further comments for this? 



