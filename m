Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757029Ab2JQNig (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 09:38:36 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:48752 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756826Ab2JQNif (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 09:38:35 -0400
Message-ID: <507EB4D2.5060605@gmail.com>
Date: Wed, 17 Oct 2012 07:38:26 -0600
From: David Ahern <dsahern@gmail.com>
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.7; rv:16.0) Gecko/20121010 Thunderbird/16.0.1
MIME-Version: 1.0
To: Xiao Guangrong <xiaoguangrong@linux.vnet.ibm.com>
CC: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org,
        peterz@infradead.org, fweisbec@gmail.com,
        Dong Hao <haodong@linux.vnet.ibm.com>
Subject: Re: [PATCH 09/12] perf kvm: split out tracepoints from record args
References: <1349716656-48165-1-git-send-email-dsahern@gmail.com> <1349716656-48165-10-git-send-email-dsahern@gmail.com> <507E6A01.1000500@linux.vnet.ibm.com>
In-Reply-To: <507E6A01.1000500@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/12 2:19 AM, Xiao Guangrong wrote:
>> -	rec_argc = ARRAY_SIZE(record_args) + argc + 2;
>> +	rec_argc = ARRAY_SIZE(record_args) + argc + 2 +
>> +		   ARRAY_SIZE(kvm_events_tp);

Lost the 2 in re-doing the set formally for distribution. I'll send a 
patch. Thanks for reviewing it.

David


