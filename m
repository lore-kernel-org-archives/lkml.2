Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab2JILHv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 07:07:51 -0400
Received: from mx1.redhat.com ([209.132.183.28]:59558 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751116Ab2JILHs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 07:07:48 -0400
Message-ID: <507404F8.8000307@redhat.com>
Date: Tue, 09 Oct 2012 07:05:28 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: John Stultz <johnstul@us.ibm.com>
CC: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH] ntp, add debugfs entries for time_status and time_state
References: <1349358521-4386-1-git-send-email-prarit@redhat.com> <50738248.7020603@us.ibm.com>
In-Reply-To: <50738248.7020603@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 10/08/2012 09:47 PM, John Stultz wrote:
> On 10/04/2012 06:48 AM, Prarit Bhargava wrote:
>> Add debugfs entries for ntp time_status and time_state.  These are useful
>> for debugging ntp issues.
> Aren't these easily fetched from adjtimex()?  How does having them in debugfs help?
> 

They are, however, there have been circumstances in the past when I've been
monitoring things from kernel-side that I've found it useful to have them in
debugfs.

P.

> thanks
> -john
> 
