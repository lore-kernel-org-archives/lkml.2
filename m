Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756760Ab0CWBl1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Mar 2010 21:41:27 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63811 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756235Ab0CWBlZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Mar 2010 21:41:25 -0400
Message-ID: <4BA81D18.40509@redhat.com>
Date: Tue, 23 Mar 2010 09:44:56 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Matt Mackall <mpm@selenic.com>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, elendil@planet.nl,
       David Miller <davem@davemloft.net>
Subject: Re: [Patch v2] netpoll: warn when there are spaces in parameters
References: <20100322090341.5289.10770.sendpatchset@localhost.localdomain> <1269296535.3552.10.camel@calx>
In-Reply-To: <1269296535.3552.10.camel@calx>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Matt Mackall wrote:
> On Mon, 2010-03-22 at 04:59 -0400, Amerigo Wang wrote:
>> +			printk(KERN_INFO "%s: warning: whitespace"
>> +					"is not allowed\n", np->name);
> 
> Is it a warning or is it info? If it's a warning, then we probably need
> to add "netpoll" or whatever to the message so that people who've got a
> warning-level threshold will know what it's about.
> 

If you mean KERN_INFO, yeah, I want to keep it in the same level
as other messages around.

Also, I already put "np->name" which will be "netconsole" when
we use netconsole.

Thanks.
