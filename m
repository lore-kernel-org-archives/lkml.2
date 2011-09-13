Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756144Ab1IMSU1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Sep 2011 14:20:27 -0400
Received: from merlin.infradead.org ([205.233.59.134]:43849 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755870Ab1IMSUZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Sep 2011 14:20:25 -0400
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
Date: Tue, 13 Sep 2011 20:19:55 +0200
In-Reply-To: <20110913175425.GB3062@linux.vnet.ibm.com>
References: <1315571462.26517.9.camel@twins>
	 <20110912101722.GA28950@linux.vnet.ibm.com>
	 <1315830943.26517.36.camel@twins>
	 <20110913041545.GD11100@linux.vnet.ibm.com>
	 <20110913050306.GB7254@linux.vnet.ibm.com> <1315906788.575.3.camel@twins>
	 <20110913112852.GE7254@linux.vnet.ibm.com> <1315922848.5977.11.camel@twins>
	 <20110913162119.GA3045@linux.vnet.ibm.com> <1315931775.5977.29.camel@twins>
	 <20110913175425.GB3062@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
X-Mailer: Evolution 3.0.3- 
Message-ID: <1315937995.4226.9.camel@twins>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-09-13 at 23:24 +0530, Srivatsa Vaddagiri wrote:
> We saw considerably high migration count on latest tip compared to
> previous kernels. Kamalesh, can you please post the migration count
> data? 

Hrmm, yes this looks horrid.. even without cgroup crap, something's
funny.
