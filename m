Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752951Ab0CRMed (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 08:34:33 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43372 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752723Ab0CRMeb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 08:34:31 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Avi Kivity <avi@redhat.com>, Alexander Graf <agraf@suse.de>,
       Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
References: <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws>
	<20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws>
	<20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com>
	<20100318085607.GB2157@elte.hu>
	<F0F75B33-C0BA-42EB-BFC4-D60B1E232E6D@suse.de>
	<20100318101025.GA13073@elte.hu> <4BA1FEB0.7000400@redhat.com>
	<20100318113527.GA13168@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Thu, 18 Mar 2010 08:33:48 -0400
In-Reply-To: <20100318113527.GA13168@elte.hu> (Ingo Molnar's message of "Thu, 18 Mar 2010 12:35:27 +0100")
Message-ID: <y0m4okdzu4z.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ingo Molnar <mingo@elte.hu> writes:

> [...]
> Distributions are very eager to update kernels even in stable periods of the 
> distro lifetime - they are much less willing to update user-space packages.
> [...]

Sorry, er, what?  What distributions eagerly upgrade kernels in stable
periods, were it not primarily motivated by security fixes?  What users
eagerly replace their kernels?

- FChE
