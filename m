Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760490Ab0KRVHA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Nov 2010 16:07:00 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:19036 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760404Ab0KRVG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Nov 2010 16:06:59 -0500
Message-ID: <4CE5956D.5020507@caviumnetworks.com>
Date: Thu, 18 Nov 2010 13:06:53 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: Grant Likely <grant.likely@secretlab.ca>,
        David Miller <davem@davemloft.net>
CC: devicetree-discuss@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] phylib: Add support for Marvell 88E1149R devices.
References: <1290038071-13296-1-git-send-email-ddaney@caviumnetworks.com> <1290038071-13296-3-git-send-email-ddaney@caviumnetworks.com> <20101118.114616.258106719.davem@davemloft.net> <20101118204410.GB16908@angua.secretlab.ca>
In-Reply-To: <20101118204410.GB16908@angua.secretlab.ca>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Nov 2010 21:07:48.0705 (UTC) FILETIME=[A782FD10:01CB8764]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/18/2010 12:44 PM, Grant Likely wrote:
> On Thu, Nov 18, 2010 at 11:46:16AM -0800, David Miller wrote:
>> From: David Daney<ddaney@caviumnetworks.com>
>> Date: Wed, 17 Nov 2010 15:54:31 -0800
>>
>>> The 88E1149R is 10/100/1000 quad-gigabit Ethernet PHY.  The
>>> .config_aneg function can be shared with 88E1118, but it needs its own
>>> .config_init.
>>>
>>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>>
>> Please resend this when you've respun patch #1 based upon the feedback
>> you've been given.
>
> It looks to me that this patch has no dependencies on the first patch.
> ddaney; what say you?
>

It calls the marvell_of_reg_init() function introduced in the first 
patch.  Reordering the patches would be possible, but since nobody else 
has cared enough to add 88E1149R support, it shouldn't affect anyone be 
me.

I arbitrarily ordered it this way.  If davem wishes, I could re-order 
the patches and 88E1149R could be merged before the device tree part.

David Daney
