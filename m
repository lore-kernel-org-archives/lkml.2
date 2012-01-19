Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757308Ab2ASJ3q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jan 2012 04:29:46 -0500
Received: from www.linutronix.de ([62.245.132.108]:56086 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756561Ab2ASJ3d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jan 2012 04:29:33 -0500
Message-ID: <4F17E27B.8070308@linutronix.de>
Date: Thu, 19 Jan 2012 10:29:31 +0100
From: Richard Weinberger <rw@linutronix.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:9.0) Gecko/20111220 Thunderbird/9.0
MIME-Version: 1.0
To: Pablo Neira Ayuso <pablo@netfilter.org>
CC: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rostedt@goodmis.org
Subject: Re: Netfilter: New target: RLOG
References: <1326926610-17830-1-git-send-email-rw@linutronix.de> <20120119091248.GA32391@1984> <20120119092533.GA32602@1984>
In-Reply-To: <20120119092533.GA32602@1984>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19.01.2012 10:25, Pablo Neira Ayuso wrote:
> On Thu, Jan 19, 2012 at 10:12:48AM +0100, Pablo Neira Ayuso wrote:
>> I still think this can be useful.
>>
>> But, why don't you add this to the LOG target as an extension instead
>> of yet another target?
>
> By "extension", I meant to say "revision".
>
> If you're not familiar with the iptables revision mechanism, for
> instance, have a look at net/netfilter/xt_NFQUEUE.c
>
> Look for the "revision" pattern in that code. Basicaly, it allows you
> to enhance existing matches/targets without breaking backward
> compatibility.

Okay, will look and send new patches. :-)

Thanks,
//richard
