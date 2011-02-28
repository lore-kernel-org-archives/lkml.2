Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752465Ab1B1DzT (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Feb 2011 22:55:19 -0500
Received: from sj-iport-5.cisco.com ([171.68.10.87]:35693 "EHLO
	sj-iport-5.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752410Ab1B1DzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Feb 2011 22:55:17 -0500
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAJ6rak2rRN+K/2dsb2JhbACmRHSfZJpjhWEEhRCHDYM+
X-IronPort-AV: E=Sophos;i="4.62,237,1297036800"; 
   d="scan'208";a="335906755"
Message-ID: <4D6B1CB0.8020704@cisco.com>
Date: Sun, 27 Feb 2011 20:55:28 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc14 Thunderbird/3.1.7
MIME-Version: 1.0
To: linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org
CC: acme@ghostprotocols.net, mingo@elte.hu, peterz@infradead.org,
        fweisbec@gmail.com, paulus@samba.org, tglx@linutronix.de
Subject: Re: [PATCH 0/6 v3] perf events: Add realtime clock event, time-of-day
 strings to script output
References: <1298865151-23656-1-git-send-email-daahern@cisco.com>
In-Reply-To: <1298865151-23656-1-git-send-email-daahern@cisco.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/27/2011 08:52 PM, David Ahern wrote:
> A request was made to modify perf-trace and perf-script. From what I can see
> perf-trace does not exist yet and perf-script requires raw data which means
> it does not work for the primary use case that motivated this feature
> (perf record -e cs -1 -ag).

Please disregard the above; it is not relevant to this version.

David
