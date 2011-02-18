Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754591Ab1BRPfv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 10:35:51 -0500
Received: from sj-iport-4.cisco.com ([171.68.10.86]:59939 "EHLO
	sj-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751209Ab1BRPft (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 10:35:49 -0500
Authentication-Results: sj-iport-4.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EAOsgXk1AaMHG/2dsb2JhbACEH6IEc6BRinuQP4Eng0F2BIULhwaDOg
X-IronPort-AV: E=Sophos;i="4.62,187,1297036800"; 
   d="scan'208";a="261974135"
Message-ID: <4D5E91CF.60509@cisco.com>
Date: Fri, 18 Feb 2011 08:35:43 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, acme@ghostprotocols.net, paulus@samba.org
Subject: Re: [PATCH 2/3] perf events: Introduce realtime clock event
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>	 <1298008433-22911-3-git-send-email-daahern@cisco.com>	 <1298027641.5226.666.camel@laptop>  <4D5E84AC.4040104@cisco.com> <1298041106.5226.775.camel@laptop>
In-Reply-To: <1298041106.5226.775.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 07:58, Peter Zijlstra wrote:
> Well, but you can fix that, simply add PERF_SAMPLE_READ, no need to
> abuse the raw crap.
> 

Ok I see how this option works kernel side. It's not plumbed userspace side:
	if (type & PERF_SAMPLE_READ) {
		fprintf(stderr, "PERF_SAMPLE_READ is unsuported for now\n");
		return -1;
	}

I'll take a look at that.

David

> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
