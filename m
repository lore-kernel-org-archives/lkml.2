Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751180Ab2CGFeF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 00:34:05 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:38915 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1749667Ab2CGFeD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 00:34:03 -0500
Message-ID: <4F56F340.50504@gmail.com>
Date: Tue, 06 Mar 2012 21:33:52 -0800
From: "l.a.y.3.r.2" <l.a.y.3.r.2@gmail.com>
Reply-To: l.a.y.3.r.2@gmail.com
Organization: None
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:10.0.2) Gecko/20120216 Thunderbird/10.0.2
MIME-Version: 1.0
To: Eric Dumazet <eric.dumazet@gmail.com>
CC: linux-kernel@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        David Miller <davem@davemloft.net>
Subject: Re: potential kernel bug
References: <4F56CA3E.1040405@gmail.com> <1331097450.2474.52.camel@edumazet-laptop>
In-Reply-To: <1331097450.2474.52.camel@edumazet-laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Excellent. I'll prepare a writeup of the suspect behaviors tomorrow
afternoon after work. Thank you for the prompt and courteous response.

L2

On 03/06/2012 09:17 PM, Eric Dumazet wrote:
> Le mardi 06 mars 2012 à 18:38 -0800, l.a.y.3.r.2 a écrit :
>> Hello,
>>
>> I think I may have found a bug in the functionality of the kernel and
>> iptables. I am concerned that it may be too sensitive to publicly
>> disclose the exact details.
>>
>> Can you please provide me with some guidance on how to provide
>> additional details in a secure manner?
>>
> 
> Submit a mail to developers, and if you really believe a _high_ security
> issue exists, to security@kernel.org
> 
> But you know, we fix such bugs every day...
> 
> List of involved people (if you want to stay private) : 
> 
> Pablo Neira Ayuso <pablo@netfilter.org>
> David Miller <davem@davemloft.net>
> 
> You can add me too.
> 
> 
