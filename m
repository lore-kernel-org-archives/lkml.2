Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab0JSNWO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 09:22:14 -0400
Received: from mga14.intel.com ([143.182.124.37]:32010 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758001Ab0JSNWN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 09:22:13 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.57,350,1283756400"; 
   d="scan'208";a="337831717"
Message-ID: <4CBD9B7F.6040307@linux.intel.com>
Date: Tue, 19 Oct 2010 15:22:07 +0200
From: Andi Kleen <ak@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.1; en-US; rv:1.9.2.9) Gecko/20100915 Thunderbird/3.1.4
MIME-Version: 1.0
To: Amerigo Wang <amwang@redhat.com>
CC: linux-kernel@vger.kernel.org, Randy Dunlap <rdunlap@xenotime.net>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Len Brown <len.brown@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Howells <dhowells@redhat.com>, Eric Paris <eparis@redhat.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Eric Dumazet <eric.dumazet@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Andy Shevchenko <ext-andriy.shevchenko@nokia.com>,
        linux-doc@vger.kernel.org
Subject: Re: [PATCH 2/2] sysctl: remove sysctl syscall
References: <1287476560-5874-1-git-send-email-amwang@redhat.com> <1287476560-5874-2-git-send-email-amwang@redhat.com>
In-Reply-To: <1287476560-5874-2-git-send-email-amwang@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 10/19/2010 10:22 AM, Amerigo Wang wrote:
> Remove the obsolete sysctl syscall. It was scheduled
> to be removed in Sept.


I thought at least older glibc was still using it? Did anyone check
what happens if it sees no sysctl(2)?

I think it's ok to remove the full tables, but keeping
a wrapper just for the functionality glibc use(s/d) is still a good
idea.

-Andi

