Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519Ab0CRTvN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 15:51:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:20287 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751926Ab0CRTvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 15:51:12 -0400
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Avi Kivity <avi@redhat.com>, Ingo Molnar <mingo@elte.hu>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
References: <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com>
	<20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws>
	<20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws>
	<20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com>
	<20100318092232.GC2157@elte.hu> <4BA20153.5060409@redhat.com>
	<20100318182048.GC5103@nowhere>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 18 Mar 2010 15:50:37 -0400
In-Reply-To: <20100318182048.GC5103@nowhere> (Frederic Weisbecker's message of "Thu, 18 Mar 2010 19:20:52 +0100")
Message-ID: <y0mk4t9xvci.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Frederic Weisbecker <fweisbec@gmail.com> writes:

> [...]  It is actually because both kernel and user side are sync in
> this scheme.  [...]

This argues that co-evolution of an interface is easiest on the
developers if they own both sides of that interface.  No quarrel.

This does not argue that that the preservation of a stable ABI is best
done this way.  If anything, it makes it too easy to change both the
provider and the preferred user of the interface without noticing
unintentional breakage to forlorn out-of-your-tree clients.


- FChE
