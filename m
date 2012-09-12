Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757612Ab2ILO5h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Sep 2012 10:57:37 -0400
Received: from mx1.redhat.com ([209.132.183.28]:58809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751605Ab2ILO5g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Sep 2012 10:57:36 -0400
Message-ID: <5050A2D8.7080908@redhat.com>
Date: Wed, 12 Sep 2012 10:57:28 -0400
From: Jon Masters <jcm@redhat.com>
Organization: Red Hat, Inc.
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Steven Rostedt <rostedt@goodmis.org>
CC: LKML <linux-kernel@vger.kernel.org>, RT <linux-rt-users@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Darren Hart <dvhart@linux.intel.com>,
        Clark Williams <clark@redhat.com>
Subject: Re: [PATCH RT] hwlat_detector: Check the outer side of the loop
References: <1347460451.10751.57.camel@gandalf.local.home>
In-Reply-To: <1347460451.10751.57.camel@gandalf.local.home>
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/12/2012 10:34 AM, Steven Rostedt wrote:
> The hwlat_detector performs the following test:
>
> 	t1 = ktime_get();
> 	t2 = ktime_get();
>
> 	[ do the checks of t2 - t1 ]
>
> It can detect things like SMIs if it occurs between the t1 and t2
> timestamps, as there will be a large difference between the two.

Oops. Good catch.

Jon.

