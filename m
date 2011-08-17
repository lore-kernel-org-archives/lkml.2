Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987Ab1HQL3e (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Aug 2011 07:29:34 -0400
Received: from mail-iy0-f170.google.com ([209.85.210.170]:48020 "EHLO
	mail-iy0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751119Ab1HQL3c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Aug 2011 07:29:32 -0400
Message-ID: <4E4BA614.80709@secretlab.ca>
Date: Wed, 17 Aug 2011 05:29:24 -0600
From: Grant Likely <glikely@secretlab.ca>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        David Daney <david.daney@cavium.com>, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, Grant Likely <grant.likely@secretlab.ca>
Subject: Re: [PATCH] pci/of: Don't crash when bridge parent is NULL.
References: <1313519077-18457-1-git-send-email-david.daney@cavium.com>	<1313522178.3664.69.camel@pasglop> <20110816211109.13c80d34@jbarnes-e6510>
In-Reply-To: <20110816211109.13c80d34@jbarnes-e6510>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11-08-16 10:11 PM, Jesse Barnes wrote:
> On Tue, 16 Aug 2011 14:16:18 -0500
> Benjamin Herrenschmidt<benh@kernel.crashing.org>  wrote:
>
>> On Tue, 2011-08-16 at 11:24 -0700, David Daney wrote:
>>> In pcibios_get_phb_of_node(), we will crash while booting if
>>> bus->bridge->parent is NULL.
>>>
>>> Check for this case and avoid dereferencing the NULL pointer.
>>>
>>> Signed-off-by: David Daney<david.daney@cavium.com>
>>
>> Acked-by: Benjamin Herrenschmidt<benh@kernel.crashing.org>
>>
>> Jesse or Grant, I'm travelling, can any of you send that to Linus
>> asap ?
>
> Sure looks fine.  I'll send it off tomorrow (now that I'm back :).
>
> Thanks,
> Jesse

thanks Jesse.

Acked-by: Grant Likely <grant.likely@secretlab.ca>
