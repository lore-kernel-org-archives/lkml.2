Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753875Ab0CRSUz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Mar 2010 14:20:55 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:36515 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658Ab0CRSUx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Mar 2010 14:20:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=l+X1J+wM7sNTtJ9F1EGuDCulOEsDNhNPAFDQaWWjHbZtdx14PYp8s+9evNUYd0S4Fz
         LRMKsObwziugAWURFpEm4UiwtQAZZKiN5TQhr8EjcgjAuPIFXJJEczvh+5bgYRVbEMnE
         M2kcu10z3bjN0RhCV4cdkh2ov8bxWxNGQe+tY=
Date: Thu, 18 Mar 2010 19:20:52 +0100
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Avi Kivity <avi@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Anthony Liguori <anthony@codemonkey.ws>,
       "Zhang, Yanmin" <yanmin_zhang@linux.intel.com>,
       Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Sheng Yang <sheng@linux.intel.com>, linux-kernel@vger.kernel.org,
       kvm@vger.kernel.org, Marcelo Tosatti <mtosatti@redhat.com>,
       oerg Roedel <joro@8bytes.org>, Jes Sorensen <Jes.Sorensen@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Zachary Amsden <zamsden@redhat.com>,
       ziteng.huang@intel.com, Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: Re: [RFC] Unify KVM kernel-space and user-space code into a single
	project
Message-ID: <20100318182048.GC5103@nowhere>
References: <20100316122903.GA8831@elte.hu> <4B9F7C6A.3070207@redhat.com> <20100316130840.GA24808@elte.hu> <4B9FBA8B.8020200@codemonkey.ws> <20100316173940.GA23859@elte.hu> <4BA00F1F.1090907@codemonkey.ws> <20100317081041.GC16374@elte.hu> <4BA1E24B.6090904@redhat.com> <20100318092232.GC2157@elte.hu> <4BA20153.5060409@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BA20153.5060409@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 18, 2010 at 12:32:51PM +0200, Avi Kivity wrote:
> By "serious developer" I mean
>
>  - someone who is interested in contributing, not in getting their name  
> into the kernel commits list
>  - someone who is willing to read the wiki page and find out where the  
> repository and mailing list for a project is
>  - someone who will spend enough time on the project so that the time to 
> clone two repositories will not be a factor in their contributions


I'm not going to argue about the Qemu merging here.
But your above assessment is incomplete.

It is not because developers don't want to clone two different
trees that tools/perf is a success. Or may be it's a factor but
I suspect it to be very minimal. I can script git commands if
needed. It is actually because both kernel and user side are
sync in this scheme.



> Let's wait and see then.  If the tools/perf/ experience has really good  
> results, we can reconsider this at a later date.


I think it has already really good results.

