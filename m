Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752087Ab1GGNtM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Jul 2011 09:49:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:51770 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290Ab1GGNtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Jul 2011 09:49:11 -0400
Subject: Re: [patch 03/17] sched: introduce primitives to account for CFS
 bandwidth tracking
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Paul Turner <pjt@google.com>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Hu Tao <hutao@cn.fujitsu.com>, Nikhil Rao <ncrao@google.com>
In-Reply-To: <20110707053059.981950189@google.com>
References: <20110707053036.173186930@google.com>
	 <20110707053059.981950189@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 07 Jul 2011 15:48:44 +0200
Message-ID: <1310046524.3282.570.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-07-06 at 22:30 -0700, Paul Turner wrote:
> +config CFS_BANDWIDTH
> +       bool "CPU bandwidth provisioning for FAIR_GROUP_SCHED"
> +       depends on EXPERIMENTAL
> +       depends on FAIR_GROUP_SCHED
> +       depends on SMP 

I know that UP is quickly becoming extinct, but isn't that a tad
radical? :-)
