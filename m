Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0CQIQx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 04:16:53 -0400
Received: from mx3.mail.elte.hu ([157.181.1.138]:46673 "EHLO mx3.mail.elte.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753494Ab0CQIQu (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 04:16:50 -0400
Date: Wed, 17 Mar 2010 09:16:41 +0100
From: Ingo Molnar <mingo@elte.hu>
To: Avi Kivity <avi@redhat.com>
Cc: "Frank Ch. Eigler" <fche@redhat.com>,
       Anthony Liguori <aliguori@linux.vnet.ibm.com>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com
Subject: Re: [PATCH] Enhance perf to collect KVM guest os statistics from
 host side
Message-ID: <20100317081641.GE16374@elte.hu>
References: <20100316133114.GB575@elte.hu>
 <y0mbpeo1f1y.fsf@fche.csb>
 <20100316155221.GA19699@elte.hu>
 <4B9FC11A.1070507@linux.vnet.ibm.com>
 <20100316175243.GC23859@elte.hu>
 <4B9FC8B2.6070404@linux.vnet.ibm.com>
 <20100316182809.GA26602@elte.hu>
 <4BA00E6A.7080903@linux.vnet.ibm.com>
 <20100317004136.GC17472@redhat.com>
 <4BA05285.3070903@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA05285.3070903@redhat.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-ELTE-SpamScore: -2.0
X-ELTE-SpamLevel: 
X-ELTE-SpamCheck: no
X-ELTE-SpamVersion: ELTE 2.0 
X-ELTE-SpamCheck-Details: score=-2.0 required=5.9 tests=BAYES_00 autolearn=no SpamAssassin version=3.2.5
	-2.0 BAYES_00               BODY: Bayesian spam probability is 0 to 1%
	[score: 0.0000]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Avi Kivity <avi@redhat.com> wrote:

> Monitoring guests from the host is useful for kvm developers, but less so 
> for users.

Guest space profiling is easy, and 'perf kvm' is not about that. (plain 'perf' 
will work if a proper paravirt channel is opened to the host)

I think you might have misunderstood the purpose and role of the 'perf kvm' 
patch here? 'perf kvm' is aimed at KVM developers: it is them who improve KVM 
code, not guest kernel users.

	Ingo
