Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759203Ab2GLMcL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 08:32:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:8342 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758979Ab2GLMcI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 08:32:08 -0400
Message-ID: <4FFEC342.2060107@redhat.com>
Date: Thu, 12 Jul 2012 08:29:54 -0400
From: Prarit Bhargava <prarit@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110419 Red Hat/3.1.10-1.el6_0 Thunderbird/3.1.10
MIME-Version: 1.0
To: Jan Ceuleers <jan.ceuleers@computer.org>
CC: John Stultz <johnstul@us.ibm.com>, Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, stable@vger.kernel.org
Subject: Re: [PATCH 1/6] hrtimer: Provide clock_was_set_delayed()
References: <1341960205-56738-1-git-send-email-johnstul@us.ibm.com> <1341960205-56738-2-git-send-email-johnstul@us.ibm.com> <4FFD6E5A.9060206@redhat.com> <alpine.LFD.2.02.1207111425260.32033@ionos> <1342011904.3462.152.camel@twins> <alpine.LFD.2.02.1207111539060.32033@ionos> <4FFDAE1D.3050008@us.ibm.com> <4FFE804A.8070205@computer.org>
In-Reply-To: <4FFE804A.8070205@computer.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 07/12/2012 03:44 AM, Jan Ceuleers wrote:
> On 07/11/2012 06:47 PM, John Stultz wrote:
>> I'll see if my worry is unfounded, but it might be a bit too clever for rare events.
> 
> Full ACK.
> 
> There is an unfortunate history of critical-to-moderately-serious bugs in
> the leap second handling, so I submit that what is needed is a simple,
> obviously-correct and robust mechanism. Robust statically, but also in the
> face of code churn because these code paths are exercised so rarely out in
> the wild.
> 
> Just my opinion, FWIW.
> 

Ditto - and it's not just FWIW.

John (and everyone else), I think we're over-thinking this.  Would it be nice to
get an extremely elegant solution to this?  Yeah ... it would.  But the reality
is that we're not going to get there and IMO we're making things too complex for
this little piece of code.

Acked-by: Prarit Bhargava <prarit@redhat.com>

IMO, this is the simplest way to move forward with this code.

P.

