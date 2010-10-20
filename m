Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752371Ab0JTIiP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Oct 2010 04:38:15 -0400
Received: from hera.kernel.org ([140.211.167.34]:48829 "EHLO hera.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab0JTIiN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Oct 2010 04:38:13 -0400
Message-ID: <4CBEAA6E.2060000@kernel.org>
Date: Wed, 20 Oct 2010 10:38:06 +0200
From: Tejun Heo <tj@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux i686 (x86_64); en-US; rv:1.9.2.9) Gecko/20100915 Lightning/1.0b2 Thunderbird/3.1.4
MIME-Version: 1.0
To: Bart Van Assche <bvanassche@acm.org>
CC: Roland Dreier <rolandd@cisco.com>, Sean Hefty <sean.hefty@intel.com>,
        Hal Rosenstock <hal.rosenstock@gmail.com>, linux-rdma@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2.6.36-rc7] infiniband: update workqueue usage
References: <4CBDB834.2050905@kernel.org> <AANLkTi=gYununGYK-QuonZASyk49Rj2-+zG+f22fBF=g@mail.gmail.com>
In-Reply-To: <AANLkTi=gYununGYK-QuonZASyk49Rj2-+zG+f22fBF=g@mail.gmail.com>
X-Enigmail-Version: 1.1.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.3 (hera.kernel.org [127.0.0.1]); Wed, 20 Oct 2010 08:38:07 +0000 (UTC)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 10/19/2010 08:40 PM, Bart Van Assche wrote:
> On Tue, Oct 19, 2010 at 5:24 PM, Tejun Heo <tj@kernel.org> wrote:
>> [ ... ]
>> This is to prepare for deprecation of flush_scheduled_work().
>> [ ... ]
>> Index: work/include/rdma/ib_verbs.h
>> [ ... ]
>> +extern struct workqueue_struct *ib_wq;
>> [ ... ]
> 
> This patch adds a declaration of a global variable to a public header
> file. That might be unavoidable, but it doesn't make me happy.

Hmm... that's one very interesting reason to be unhappy.  Can you
please elaborate why addition of a global variable doesn't make you
happy?

Thanks.

-- 
tejun
