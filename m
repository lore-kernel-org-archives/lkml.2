Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520Ab2ECEic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 00:38:32 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:58956 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750878Ab2ECEia (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 00:38:30 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-mm@kvack.org, mgorman@suse.de, kamezawa.hiroyu@jp.fujitsu.com,
        dhillf@gmail.com, aarcange@redhat.com, mhocko@suse.cz,
        akpm@linux-foundation.org, hannes@cmpxchg.org,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        linux-next@vger.kernel.org
Subject: Re: [PATCH -V6 07/14] memcg: Add HugeTLB extension
In-Reply-To: <CAP=VYLqgaCabQGDVgUXnCwKCZHtz0nWxpm_a6Cgz_ciMzGe9gQ@mail.gmail.com>
References: <1334573091-18602-1-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <1334573091-18602-8-git-send-email-aneesh.kumar@linux.vnet.ibm.com> <CAP=VYLqgaCabQGDVgUXnCwKCZHtz0nWxpm_a6Cgz_ciMzGe9gQ@mail.gmail.com>User-Agent: Notmuch/0.11.1+346~g13d19c3 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Thu, 03 May 2012 10:07:59 +0530
Message-ID: <87pqalhobc.fsf@skywalker.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12050304-4790-0000-0000-00000271B4AC
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Paul Gortmaker <paul.gortmaker@windriver.com> writes:

> On Mon, Apr 16, 2012 at 6:44 AM, Aneesh Kumar K.V
> <aneesh.kumar@linux.vnet.ibm.com> wrote:
>> From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
>>
>> This patch implements a memcg extension that allows us to control HugeTLB
>> allocations via memory controller. The extension allows to limit the
>
> Hi Aneesh,
>
> This breaks linux-next on some arch because they don't have any
> HUGE_MAX_HSTATE in scope with the current #ifdef layout.
>
> The breakage is in sh4, m68k, s390, and possibly others.
>
> http://kisskb.ellerman.id.au/kisskb/buildresult/6228689/
> http://kisskb.ellerman.id.au/kisskb/buildresult/6228670/
> http://kisskb.ellerman.id.au/kisskb/buildresult/6228484/
>
> This is a commit in akpm's mmotm queue, which used to be here:
>
> http://userweb.kernel.org/~akpm/mmotm
>
> Of course the above is invalid since userweb.kernel.org is dead.
> I don't have a post-kernel.org break-in link handy and a quick
> search didn't give me one, but I'm sure you'll recognize the change.
>

Andrew have the below patch 

http://article.gmane.org/gmane.linux.kernel.commits.mm/71649

Does that fix the error ?

-aneesh

