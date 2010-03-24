Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738Ab0CXFJx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Mar 2010 01:09:53 -0400
Received: from one.firstfloor.org ([213.235.205.2]:41494 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751394Ab0CXFJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Mar 2010 01:09:51 -0400
To: Joerg Roedel <joro@8bytes.org>
Cc: Avi Kivity <avi@redhat.com>, Anthony Liguori <anthony@codemonkey.ws>,
       Ingo Molnar <mingo@elte.hu>, Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>,
       Gregory Haskins <ghaskins@novell.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
From: Andi Kleen <andi@firstfloor.org>
References: <4BA796DF.7090005@redhat.com> <20100322165107.GD18796@elte.hu>
	<4BA7A406.9050203@redhat.com> <20100322173400.GB15795@elte.hu>
	<4BA7B9E0.5080009@codemonkey.ws> <20100322192739.GE21919@elte.hu>
	<4BA7C96D.2020702@redhat.com> <4BA7E9D9.5060800@codemonkey.ws>
	<20100323140608.GJ1940@8bytes.org> <4BA8EEDE.8070309@redhat.com>
	<20100323182153.GA14800@8bytes.org>
Date: Wed, 24 Mar 2010 06:09:45 +0100
In-Reply-To: <20100323182153.GA14800@8bytes.org> (Joerg Roedel's message of "Tue, 23 Mar 2010 19:21:53 +0100")
Message-ID: <87hbo6fgpy.fsf@basil.nowhere.org>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/22.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Joerg Roedel <joro@8bytes.org> writes:
>
> Sidenote: I really think we should come to a conclusion about the
>           concept. KVM integration into perf is very useful feature to
> 	  analyze virtualization workloads.

Agreed. I especially would like to see instruction/branch tracing
working this way.  This would a lot of the benefits of a simulator on
a real CPU.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
