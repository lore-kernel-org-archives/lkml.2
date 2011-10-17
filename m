Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756251Ab1JQPl2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Oct 2011 11:41:28 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:8670 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056Ab1JQPl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Oct 2011 11:41:26 -0400
Message-ID: <4E9C4CA5.8020407@cavium.com>
Date: Mon, 17 Oct 2011 08:41:25 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Kumar Gala <galak@kernel.crashing.org>
CC: Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>,
        devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2 0/3] netdev/of/phy: MDIO bus multiplexer support.
References: <1317166015-20714-1-git-send-email-david.daney@cavium.com> <20110929.163112.1523715692737597332.davem@davemloft.net> <20110930003214.GB12606@ponder.secretlab.ca> <C81814FF-4E56-4B28-8043-F874EE1D6B51@kernel.crashing.org>
In-Reply-To: <C81814FF-4E56-4B28-8043-F874EE1D6B51@kernel.crashing.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Oct 2011 15:41:26.0459 (UTC) FILETIME=[3B2420B0:01CC8CE3]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2011 07:48 AM, Kumar Gala wrote:
>
> On Sep 29, 2011, at 7:32 PM, Grant Likely wrote:
>
>> On Thu, Sep 29, 2011 at 04:31:12PM -0400, David Miller wrote:
>>> From: David Daney<david.daney@cavium.com>
>>> Date: Tue, 27 Sep 2011 16:26:52 -0700
>>>
>>>> v2: Update bindings to use "reg" and "mdio-parent-bus" insutead of
>>>>     "cell-index" and "parent-bus"
>>>
>>> Grant, when the final version of this patch set is ready how do
>>> you want to handle merging it in?
>>>
>>> I think it would be safe to merge this via your tree, since the
>>> changes made to existing network driver files are rather trivial and
>>> thus merge conflict friendly.
>>
>> Your tree or mine, I'm happy either way.  Even if there were
>> conflicts, they would be trivial.
>>
>> Sure, I'll take care of merging it when I see an ack from you.
>>
>>> Actually, I feel like we've discussed this before :-)
>>
>> :)
>>
>> g.
>
> Any updates to these patches?

Not yet, so you didn't miss anything.

They are on my to-do list though

David Daney
