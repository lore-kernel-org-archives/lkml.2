Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab1IMJk1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 05:40:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48996 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185Ab1IMJk0 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 05:40:26 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned vs
 unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>
Cc: Paul Turner <pjt@google.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
Date: Tue, 13 Sep 2011 11:39:48 +0200
In-Reply-To: <20110913050306.GB7254@linux.vnet.ibm.com>
References: <BANLkTimE1b8HP-q4jgsv5jPD5S-dRoUi_g@mail.gmail.com>
	 <20110615053716.GA390@linux.vnet.ibm.com>
	 <BANLkTi=7S2qdVjbJkDja+GAoD=pNo2gPsTFZMFkB8NWWkO1JVQ@mail.gmail.com>
	 <20110907152009.GA3868@linux.vnet.ibm.com>
	 <1315423342.11101.25.camel@twins>
	 <20110908151433.GB6587@linux.vnet.ibm.com> <1315571462.26517.9.camel@twins>
	 <20110912101722.GA28950@linux.vnet.ibm.com>
	 <1315830943.26517.36.camel@twins>
	 <20110913041545.GD11100@linux.vnet.ibm.com>
	 <20110913050306.GB7254@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315906788.575.3.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 10:33 +0530, Srivatsa Vaddagiri wrote:
> 
> This is perhaps not optimal (as it may lead to more lock contentions), but 
> something to note for those who care for both capping and utilization in
> equal measure!

You meant lock inversion, which leads to more idle time :-)
