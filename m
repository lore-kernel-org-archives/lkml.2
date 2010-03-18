Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751168Ab0CRB7G (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 21:59:06 -0400
Received: from mx1.redhat.com ([209.132.183.28]:3131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750720Ab0CRB7E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 21:59:04 -0400
Message-ID: <4BA189BD.7070400@redhat.com>
Date: Thu, 18 Mar 2010 10:02:37 +0800
From: Cong Wang <amwang@redhat.com>
User-Agent: Thunderbird 2.0.0.23 (X11/20091001)
MIME-Version: 1.0
To: Frans Pop <elendil@planet.nl>
CC: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net
Subject: Re: [Patch] netpoll: warn when there are spaces in parameters
References: <20100317101635.5948.23485.sendpatchset@localhost.localdomain> <201003171158.49549.elendil@planet.nl>
In-Reply-To: <201003171158.49549.elendil@planet.nl>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Frans Pop wrote:
> Amerigo Wang wrote:
>> +               if (*cur == ' ' || *cur == '\t')
>> +                       printk(KERN_INFO "%s: warning: white spaces"
>> +                                       "are not allowed.\n", np->name);
>>
> 
> The term "white spaces" not correct. Please change the message to
> "whitespace is not allowed".
> 
> Also, it's normally not necessary to close kernel messages with a period; 
> most kernel messages do not have a closing period. Messages are not 
> sentences and the periods only help increase the kernel size.
> 

Ok, I will update it.

Thanks.

