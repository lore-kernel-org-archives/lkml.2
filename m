Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757979Ab1FVQyy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jun 2011 12:54:54 -0400
Received: from smtp-out.google.com ([216.239.44.51]:28251 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754189Ab1FVQyx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jun 2011 12:54:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=google.com; s=beta;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=aOGdqmvoYZl0naXZ5KnncY3XrD0WUV/vQZfIUGzzBcASFcCtNcgX5jJHVz4CtYLYXT
         ug1PQL5QiDHS67kkFssQ==
MIME-Version: 1.0
In-Reply-To: <1308758870.1022.53.camel@twins>
References: <20110621071649.862846205@google.com> <20110621071700.494088365@google.com>
 <1308758870.1022.53.camel@twins>
From: Paul Turner <pjt@google.com>
Date: Wed, 22 Jun 2011 09:54:20 -0700
Message-ID: <BANLkTimaFNDfMj7FOW5V9PAq9b8XfCFbT7HdH6S33Mvj9kstgg@mail.gmail.com>
Subject: Re: [patch 08/16] sched: throttle cfs_rq entities which exceed their
 local runtime
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: linux-kernel@vger.kernel.org, Bharata B Rao <bharata@linux.vnet.ibm.com>,
        Dhaval Giani <dhaval.giani@gmail.com>,
        Balbir Singh <balbir@linux.vnet.ibm.com>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Srivatsa Vaddagiri <vatsa@in.ibm.com>,
        Kamalesh Babulal <kamalesh@linux.vnet.ibm.com>,
        Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>,
        Ingo Molnar <mingo@elte.hu>, Pavel Emelyanov <xemul@openvz.org>,
        Nikhil Rao <ncrao@google.com>
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 22, 2011 at 9:07 AM, Peter Zijlstra <a.p.zijlstra@chello.nl> wrote:
> On Tue, 2011-06-21 at 00:16 -0700, Paul Turner wrote:
>> +static void throttle_cfs_rq(struct cfs_rq *cfs_rq)
>
> And yet this function isn't actually used, so the $subject is at best
> somewhat misleading.
>
> /me continues reading with the next patch :-)
>

Sorry, I should fix up the title.  The throttling is now turned on
after unthrottle support is also added so that bisections through this
series are sane.
