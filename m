Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756195Ab1CRMVx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 08:21:53 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.123]:33774 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab1CRMVq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 08:21:46 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=XYJHFtupD_QA:10 a=f3vvvKb-OT4A:10 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=L_jIeA3n_8CdkKjyVJcA:9 a=lm-jR8c12-ZcIXjRYCWiFQ-c97oA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Fri, 18 Mar 2011 08:21:44 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Lai Jiangshan <laijs@cn.fujitsu.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Jes Sorensen <jes@sgi.com>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        Tejun Heo <tj@kernel.org>, linux-altix@sgi.com,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 10/36] ia64,rcu: convert call_rcu(sn_irq_info_free) to
 kfree_rcu()
Message-ID: <20110318122144.GH14675@home.goodmis.org>
References: <4D82D7AD.2060205@cn.fujitsu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D82D7AD.2060205@cn.fujitsu.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Lai,

Something weird happened to your patch series. Patches 2-9 were properly
a reply to patch 1, but from this patch forward, each patch was its own
separate thread.

-- Steve

