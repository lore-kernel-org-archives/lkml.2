Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1IWXlr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Sep 2011 19:41:47 -0400
Received: from smtp-out.google.com ([74.125.121.67]:47687 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751900Ab1IWXlp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Sep 2011 19:41:45 -0400
DomainKey-Signature: a=rsa-sha1; s=beta; d=google.com; c=nofws; q=dns;
	h=dkim-signature:mime-version:in-reply-to:references:date:
	message-id:subject:from:to:cc:content-type:
	content-transfer-encoding:x-system-of-record;
	b=RmOGORqmonCXSgOffjwbB3NcCbQuh3O3AtsypVsE2zd/mEUf7c2lGWupLlyJaWQf8
	9yYvULSsM/IFHkGNEtmZg==
MIME-Version: 1.0
In-Reply-To: <1316807718.9084.48.camel@twins>
References: <1316804080-6396-1-git-send-email-venki@google.com>
	<1316807718.9084.48.camel@twins>
Date: Fri, 23 Sep 2011 16:41:41 -0700
Message-ID: <CABeCy1Zn0GbAzFBYk1mkDvfEwr4L8DZ-ZhweXaUwWN=3sJnmSQ@mail.gmail.com>
Subject: Re: [RFC] Introduce greedy hrtimer walk on idle
From: Venki Pallipadi <venki@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Suresh Siddha <suresh.b.siddha@intel.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 12:55 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2011-09-23 at 11:54 -0700, Venkatesh Pallipadi wrote:
>> Comments?
>
> One of the reasons we didn't do it before was added cost to
> hrtimer_{add,del}, did you measure workloads that are heavy on  that?
>

I haven't seen any measurable overhead with workloads I have tried.
But, I don't think I have hit that path hard enough. Do you have any
particular workload in mind?
