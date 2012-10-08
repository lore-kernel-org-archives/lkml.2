Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754149Ab2JHV5p (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 17:57:45 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:49016 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751963Ab2JHV5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 17:57:43 -0400
Message-ID: <50734C53.70905@gmail.com>
Date: Mon, 08 Oct 2012 15:57:39 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: linux-kernel@vger.kernel.org, mingo@kernel.org, peterz@infradead.org,
        fweisbec@gmail.com, Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: Re: [PATCH 12/12] perf kvm: add live mode
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com> <1349716656-48165-13-git-send-email-dsahern@gmail.com> <20121008203534.GF2631@ghostprotocols.net> <50733D72.9010100@gmail.com> <20121008214439.GM2631@ghostprotocols.net>
In-Reply-To: <20121008214439.GM2631@ghostprotocols.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/8/12 3:44 PM, Arnaldo Carvalho de Melo wrote:

>> On my Westmere based server I am not seeing problems with timestamps
>> and ordering (prior testing was on a Nehalem based server). It just
>> weathered a 5 minute or so barrage of > 100,000 events per second
>> (peaking at around 360k events/sec) with no problem.
>
> Interesting, but does this involves consuming samples from multiple
> CPUs?

yes. 4 vcpus that can and do roam the pcpus.

David

