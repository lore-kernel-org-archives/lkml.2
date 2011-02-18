Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754290Ab1BRRRa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Feb 2011 12:17:30 -0500
Received: from sj-iport-1.cisco.com ([171.71.176.70]:3201 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751665Ab1BRRR3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Feb 2011 12:17:29 -0500
Authentication-Results: sj-iport-1.cisco.com; dkim=neutral (message not signed) header.i=none
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: Av0EALI3Xk2rRN+K/2dsb2JhbACEH6IGc6AFinuQPIEng0F2BIULhwaDOoIa
X-IronPort-AV: E=Sophos;i="4.62,188,1297036800"; 
   d="scan'208";a="408923533"
Message-ID: <4D5EA9A8.2080209@cisco.com>
Date: Fri, 18 Feb 2011 10:17:28 -0700
From: David Ahern <daahern@cisco.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.13) Gecko/20101209 Fedora/3.1.7-0.35.b3pre.fc13 Thunderbird/3.1.7
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        linux-perf-users@vger.kernel.org, linux-kernel@vger.kernel.org,
        mingo@elte.hu, paulus@samba.org
Subject: Re: [PATCH 1/3] perf events: fix WARN_ON_ONCE for 64-bit raw data,
 SW events
References: <1298008433-22911-1-git-send-email-daahern@cisco.com>	 <1298008433-22911-2-git-send-email-daahern@cisco.com>	 <1298026821.5226.642.camel@laptop> <4D5E8338.8010602@cisco.com>	 <20110218145348.GA302@ghostprotocols.net>	 <1298041291.5226.776.camel@laptop>	 <20110218170450.GB302@ghostprotocols.net> <1298049189.2887.1.camel@twins> <4D5EA922.1090709@cisco.com>
In-Reply-To: <4D5EA922.1090709@cisco.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 02/18/11 10:15, David Ahern wrote:

>> Its just that any custom payload must be of size 4+8*n bytes.
> 
> 4 + 8*n != 8-byte aligned for any whole number n.

nevermind. you are referring to the payload only; I was thinking full
raw sample.


> 
> David
> --
> To unsubscribe from this list: send the line "unsubscribe linux-perf-users" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
