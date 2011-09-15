Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935200Ab1IOVtN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Sep 2011 17:49:13 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48880 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935190Ab1IOVtM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Sep 2011 17:49:12 -0400
Subject: Re: CFS Bandwidth Control - Test results of cgroups tasks pinned
 vs unpinnede
From: Peter Zijlstra <a.p.zijlstra@chello.nl>
To: Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>
Cc: Srivatsa Vaddagiri <vatsa@linux.vnet.ibm.com>,
        Paul Turner <pjt@google.com>,
        Vladimir Davydov <vdavydov@parallels.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelianov <xemul@parallels.com>
In-Reply-To: <20110915175537.GA17701@linux.vnet.ibm.com>
References: <1315906788.575.3.camel@twins>
	 <20110913112852.GE7254@linux.vnet.ibm.com> <1315922848.5977.11.camel@twins>
	 <20110913162119.GA3045@linux.vnet.ibm.com> <1315931775.5977.29.camel@twins>
	 <20110913175425.GB3062@linux.vnet.ibm.com> <1315937995.4226.9.camel@twins>
	 <20110913182841.GO11100@linux.vnet.ibm.com>
	 <1315938646.4226.12.camel@twins>
	 <20110913183502.GP11100@linux.vnet.ibm.com>
	 <20110915175537.GA17701@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Date: Thu, 15 Sep 2011 23:48:43 +0200
Message-ID: <1316123323.4060.24.camel@twins>
Mime-Version: 1.0
X-Mailer: Evolution 3.0.3- 
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-09-15 at 23:25 +0530, Kamalesh Babulal wrote:
> 2.6.38          | 1551  | 48    | 62    | 47    | 50    |
> ----------------+-------+-------+-------+-------+-------+
> 2.6.39          | 3784  | 457   | 722   | 3209  | 1037  | 

I'd say we wrecked it going from .38 to .39 and only made it worse after
that.
