Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753475Ab1L0JwA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Dec 2011 04:52:00 -0500
Received: from mx1.redhat.com ([209.132.183.28]:38897 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751455Ab1L0Jv6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Dec 2011 04:51:58 -0500
Message-ID: <4EF99532.3010803@redhat.com>
Date: Tue, 27 Dec 2011 11:51:46 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:8.0) Gecko/20111115 Thunderbird/8.0
MIME-Version: 1.0
To: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
CC: Ingo Molnar <mingo@elte.hu>, peterz@infradead.org,
        linux-kernel@vger.kernel.org, vatsa@linux.vnet.ibm.com,
        bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <87vcp4t45p.fsf@linux.vnet.ibm.com> <877h1iu2md.fsf@linux.vnet.ibm.com> <4EF98D29.1080809@redhat.com> <87ty4mic23.fsf@abhimanyu.in.ibm.com>
In-Reply-To: <87ty4mic23.fsf@abhimanyu.in.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/27/2011 11:44 AM, Nikunj A Dadhania wrote:
> > > I am seeing a drop of ~44% when setting yield_on_hlt = 0
> > >
> > 
> > A drop of 44% of what?
> > 
> records/sec
>
> Ebizzy - 2VM running in parallel, both having gang scheduling enabled.
>
>                     yield_on_hlt=1         yield_on_hlt=0
>  EbzyRecords/sec      41955.50               23285.00            -44 
>
>

Interesting, are you overcommitting vcpus?

-- 
error compiling committee.c: too many arguments to function

