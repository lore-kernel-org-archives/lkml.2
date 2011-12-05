Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932730Ab1LERmK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Dec 2011 12:42:10 -0500
Received: from e28smtp02.in.ibm.com ([122.248.162.2]:54571 "EHLO
	e28smtp02.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754583Ab1LERlw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Dec 2011 12:41:52 -0500
Message-ID: <4EDD0254.10408@linux.vnet.ibm.com>
Date: Mon, 05 Dec 2011 23:11:40 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: rjw@sisk.pl, pavel@ucw.cz, len.brown@intel.com, ebiederm@xmission.com,
        rdunlap@xenotime.net, linux-doc@vger.kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, Oleg Nesterov <oleg@redhat.com>
Subject: Re: [PATCH 1/3] PM / Sleep: Make [un]lock_system_sleep() generic
References: <20111204200208.25620.515.stgit@srivatsabhat.in.ibm.com> <20111205171443.GB627@google.com> <4EDCFE9F.9050605@linux.vnet.ibm.com> <20111205173057.GE627@google.com>
In-Reply-To: <20111205173057.GE627@google.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120517-5816-0000-0000-0000005259E4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/05/2011 11:00 PM, Tejun Heo wrote:

> (cc'ing Oleg)
> 
> On Mon, Dec 05, 2011 at 10:55:51PM +0530, Srivatsa S. Bhat wrote:
>> I wanted these APIs to be generic, not restricted to work only for userspace
>> processes. Both freezer_do_not_count() and freezer_count() are effective only
>> when current->mm is non-NULL (ie., only for userspace ones).
>> I think I have documented this in the patch which added these things to the
>> 2 APIs. See commit 6a76b7a in linux-pm/linux-next.
> 
> I see.  Oleg was curious about the ->mm condition too and IIRC there's
> no reason for that restriction.  Maybe removing that in another patch
> and using the count functions is better?
> 


Oh well, then yes, that sounds like a better idea. Will send patches for
that. Thank you.

Regards,
Srivatsa S. Bhat

