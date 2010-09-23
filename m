Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754720Ab0IWLf4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 07:35:56 -0400
Received: from mailhub.sw.ru ([195.214.232.25]:37265 "EHLO relay.sw.ru"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752952Ab0IWLfy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 07:35:54 -0400
Message-ID: <4C9B3B06.900@parallels.com>
Date: Thu, 23 Sep 2010 15:33:26 +0400
From: Pavel Emelyanov <xemul@parallels.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100720 Fedora/3.0.6-1.fc12 Thunderbird/3.0.6
MIME-Version: 1.0
To: hadi@cyberus.ca
CC: "Eric W. Biederman" <ebiederm@xmission.com>, linux-kernel@vger.kernel.org,
        Linux Containers <containers@lists.osdl.org>, netdev@vger.kernel.org,
        netfilter-devel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@free.fr>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Michael Kerrisk <mtk.manpages@gmail.com>,
        Ulrich Drepper <drepper@gmail.com>, Al Viro <viro@ZenIV.linux.org.uk>,
        David Miller <davem@davemloft.net>,
        "Serge E. Hallyn" <serge@hallyn.com>,
        Pavel Emelyanov <xemul@openvz.org>,
        Ben Greear <greearb@candelatech.com>,
        Matt Helsley <matthltc@us.ibm.com>, Jonathan Corbet <corbet@lwn.net>,
        Sukadev Bhattiprolu <sukadev@linux.vnet.ibm.com>,
        Jan Engelhardt <jengelh@medozas.de>, Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 8/8] net: Implement socketat.
References: <m1ocborgq7.fsf@fess.ebiederm.org>	 <m1bp7oq1u8.fsf@fess.ebiederm.org>  <4C9B162E.7040201@parallels.com> <1285240797.5036.5.camel@bigi>
In-Reply-To: <1285240797.5036.5.camel@bigi>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/2010 03:19 PM, jamal wrote:
> On Thu, 2010-09-23 at 12:56 +0400, Pavel Emelyanov wrote:
>> On 09/23/2010 12:51 PM, Eric W. Biederman wrote:
>>>
>>> Add a system call for creating sockets in a specified network namespace.
>>
>> What for?
> 
> I can see many uses if my understanding is correct..
> ex, from mother namespace:
> fdx = open socket at namespace blah
> from mother namespace, read/write/poll fdx 
> (eg add route with netlink socket)

This particular usecase is unneeded once you have the "enter" ability.

> cheers,
> jamal
> 
> 

