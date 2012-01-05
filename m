Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757733Ab2AECO1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jan 2012 21:14:27 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:48822 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757642Ab2AECOZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jan 2012 21:14:25 -0500
From: Nikunj A Dadhania <nikunj@linux.vnet.ibm.com>
To: Avi Kivity <avi@redhat.com>
Cc: Rik van Riel <riel@redhat.com>, Ingo Molnar <mingo@elte.hu>,
        peterz@infradead.org, linux-kernel@vger.kernel.org,
        vatsa@linux.vnet.ibm.com, bharata@linux.vnet.ibm.com
Subject: Re: [RFC PATCH 0/4] Gang scheduling in CFS
In-Reply-To: <4F046536.5080207@redhat.com>
References: <20111219083141.32311.9429.stgit@abhimanyu.in.ibm.com> <20111219112326.GA15090@elte.hu> <87sjke1a53.fsf@abhimanyu.in.ibm.com> <4EF1B85F.7060105@redhat.com> <877h1o9dp7.fsf@linux.vnet.ibm.com> <20111223103620.GD4749@elte.hu> <4EF701C7.9080907@redhat.com> <20111230095147.GA10543@elte.hu> <878vlu4bgh.fsf@linux.vnet.ibm.com> <87pqf5mqg4.fsf@abhimanyu.in.ibm.com> <4F017AD2.3090504@redhat.com> <87mxa3zqm1.fsf@abhimanyu.in.ibm.com> <4F046536.5080207@redhat.com>
User-Agent: Notmuch/0.10.2+70~gf0e0053 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-redhat-linux-gnu)
Date: Thu, 05 Jan 2012 07:40:10 +0530
Message-ID: <877h16garh.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
x-cbid: 12010502-8256-0000-0000-000000BC4906
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 04 Jan 2012 16:41:58 +0200, Avi Kivity <avi@redhat.com> wrote:
> On 01/04/2012 12:52 PM, Nikunj A Dadhania wrote:
[...]
> > I tried some experiments by adding a pause_loop_exits stat in the
> > kvm_vpu_stat.
> 
> (that's deprecated, we use tracepoints these days for stats)
> 
Ah ok, did not notice that.

