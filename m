Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756231Ab1HSQQq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Aug 2011 12:16:46 -0400
Received: from mga02.intel.com ([134.134.136.20]:29330 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753533Ab1HSQQo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Aug 2011 12:16:44 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,351,1309762800"; 
   d="scan'208";a="39487760"
Message-ID: <4E4E8C52.6070900@linux.intel.com>
Date: Fri, 19 Aug 2011 09:16:18 -0700
From: Arjan van de Ven <arjan@linux.intel.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:5.0) Gecko/20110624 Thunderbird/5.0
MIME-Version: 1.0
To: Ming Lei <tom.leiming@gmail.com>
CC: Steven Rostedt <rostedt@goodmis.org>, fweisbec@gmail.com,
        jean.pihet@newoldbits.com, mingo@redhat.com, trenn@suse.de,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org
Subject: Re: [PATCH 1/3] trace points: power: remove 'cpu_id' from trace_clock_*
References: <1313766244-22313-1-git-send-email-tom.leiming@gmail.com> <1313766840.15704.104.camel@gandalf.stny.rr.com> <CACVXFVNKe+gt2VmrHcJ2Pd1ZvqfOPn+211vR-PcM-WDTYDN4cQ@mail.gmail.com>
In-Reply-To: <CACVXFVNKe+gt2VmrHcJ2Pd1ZvqfOPn+211vR-PcM-WDTYDN4cQ@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 8/19/2011 8:39 AM, Ming Lei wrote:
> Hi,
>
> On Fri, Aug 19, 2011 at 11:14 PM, Steven Rostedt<rostedt@goodmis.org>  wrote:
>> Do you know if these changes wont break powertop?
> I have run powertop 1.13 on these changes, and found it works well
> just like before,
> no breaks found.
please use powertop 1.98 instead
1.13 does not use trace events while 1.98 does

>
> thanks,

