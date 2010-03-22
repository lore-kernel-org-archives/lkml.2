Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755175Ab0CVRSC (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 13:18:02 -0400
Received: from mx1.redhat.com ([209.132.183.28]:26069 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755039Ab0CVRR7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 13:17:59 -0400
To: Ingo Molnar <mingo@elte.hu>
Cc: Joerg Roedel <joro@8bytes.org>, Avi Kivity <avi@redhat.com>,
       Anthony Liguori <anthony@codemonkey.ws>,
       Pekka Enberg <penberg@cs.helsinki.fi>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       Jes Sorensen <Jes.Sorensen@redhat.com>, Gleb Natapov <gleb@redhat.com>,
       Zachary Amsden <zamsden@redhat.com>, ziteng.huang@intel.com,
       Arnaldo Carvalho de Melo <acme@redhat.com>,
       Fr?d?ric Weisbecker <fweisbec@gmail.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single project
References: <20100318172805.GB26067@elte.hu> <4BA32E1A.2060703@redhat.com>
	<20100319085346.GG12576@elte.hu> <4BA3747F.60401@codemonkey.ws>
	<20100321191742.GD25922@elte.hu> <4BA67B2F.4030101@redhat.com>
	<20100321203121.GA30194@elte.hu> <20100322111040.GL13108@8bytes.org>
	<20100322122228.GH3483@elte.hu> <20100322134633.GD1940@8bytes.org>
	<20100322163215.GC18796@elte.hu>
From: fche@redhat.com (Frank Ch. Eigler)
Date: Mon, 22 Mar 2010 13:17:20 -0400
In-Reply-To: <20100322163215.GC18796@elte.hu> (Ingo Molnar's message of "Mon, 22 Mar 2010 17:32:15 +0100")
Message-ID: <y0mmxy0wa1r.fsf@fche.csb>
User-Agent: Gnus/5.1008 (Gnus v5.10.8) Emacs/21.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


mingo wrote:

> [...]
>> No, the split-repository situation was the smallest problem after all. Its 
>> was a community thing. If the community doesn't work a single-repo project 
>> will also fail. [...]
>
> So, what do you think creates code communities and keeps them alive? 
> Developers and code. And the wellbeing of developers are primarily influenced 
> by the repository structure and by the development/maintenance process - i.e. 
> by the 'fun' aspect. (i'm simplifying things there but that's the crux of it.)
>
> So yes, i do claim that what stiffled and eventually killed off the Oprofile 
> community was the split repository.  [...]

In your very previous paragraphs, you enumerate two separate causes:
"repository structure" and "development/maintenance process" as being
sources of "fun".  Please simply accept that the former is considered
by many as absolutely trivial compared to the latter, and additional
verbose repetition of your thesis will not change this.

- FChE
