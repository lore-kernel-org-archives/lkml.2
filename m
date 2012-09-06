Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755185Ab2IFWmj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Sep 2012 18:42:39 -0400
Received: from mx2.parallels.com ([64.131.90.16]:37172 "EHLO mx2.parallels.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753545Ab2IFWmh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Sep 2012 18:42:37 -0400
Message-ID: <50492617.8030609@parallels.com>
Date: Fri, 7 Sep 2012 02:39:19 +0400
From: Glauber Costa <glommer@parallels.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120828 Thunderbird/15.0
MIME-Version: 1.0
To: Tejun Heo <tj@kernel.org>
CC: Peter Zijlstra <a.p.zijlstra@chello.nl>, <linux-kernel@vger.kernel.org>,
        <cgroups@vger.kernel.org>, <linux-mm@kvack.org>, <davej@redhat.com>,
        <ben@decadent.org.uk>, <pjt@google.com>, <lennart@poettering.net>,
        <kay.sievers@vrfy.org>
Subject: Re: [RFC 0/5] forced comounts for cgroups.
References: <50470A87.1040701@parallels.com> <20120905082947.GD3195@dhcp-172-17-108-109.mtv.corp.google.com> <50470EBF.9070109@parallels.com> <20120905084740.GE3195@dhcp-172-17-108-109.mtv.corp.google.com> <1346835993.2600.9.camel@twins> <20120905091140.GH3195@dhcp-172-17-108-109.mtv.corp.google.com> <50471782.6060800@parallels.com> <1346837209.2600.14.camel@twins> <50471C0C.7050600@parallels.com> <1346840453.2461.6.camel@laptop> <20120906203839.GM29092@google.com>
In-Reply-To: <20120906203839.GM29092@google.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [109.173.3.27]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/07/2012 12:38 AM, Tejun Heo wrote:
> Hello, Peter, Glauber.
> 
> (I'm gonna write up cgroup core todos which should explain / address
> this issue too.  ATM I'm a bit overwhelmed with stuff accumulated
> while traveling.)
> 

Yes, please.

While you rightfully claim that you explained it a couple of times, it
all seems to be quite fuzzy. I don't blame it on you: the current state
of the interface leads to this.

So another detailed explanation of what you envision at this point,
considering the discussions we had in the previous days, would be really
helpful,

