Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932226Ab1BWQ7b (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Feb 2011 11:59:31 -0500
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4646 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932124Ab1BWQ7a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Feb 2011 11:59:30 -0500
Message-ID: <4D653CF1.30009@caviumnetworks.com>
Date: Wed, 23 Feb 2011 08:59:29 -0800
From: David Daney <ddaney@caviumnetworks.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Gibson <david@gibson.dropbear.id.au>, linux-mips@linux-mips.org,
        ralf@linux-mips.org, devicetree-discuss@lists.ozlabs.org,
        grant.likely@secretlab.ca, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 02/10] MIPS: Octeon: Add device tree source files.
References: <1298408274-20856-1-git-send-email-ddaney@caviumnetworks.com> <1298408274-20856-3-git-send-email-ddaney@caviumnetworks.com> <20110223000759.GA26300@yookeroo>
In-Reply-To: <20110223000759.GA26300@yookeroo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 23 Feb 2011 16:59:30.0139 (UTC) FILETIME=[0957FAB0:01CBD37B]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2011 04:07 PM, David Gibson wrote:
> On Tue, Feb 22, 2011 at 12:57:46PM -0800, David Daney wrote:
>> Signed-off-by: David Daney<ddaney@caviumnetworks.com>
>> ---
>>   arch/mips/cavium-octeon/.gitignore      |    2 +
>>   arch/mips/cavium-octeon/Makefile        |   13 ++
>>   arch/mips/cavium-octeon/octeon_3xxx.dts |  314 +++++++++++++++++++++++++++++++
>>   arch/mips/cavium-octeon/octeon_68xx.dts |   99 ++++++++++
>>   4 files changed, 428 insertions(+), 0 deletions(-)
>>   create mode 100644 arch/mips/cavium-octeon/.gitignore
>>   create mode 100644 arch/mips/cavium-octeon/octeon_3xxx.dts
>>   create mode 100644 arch/mips/cavium-octeon/octeon_68xx.dts
>>
[...]

>> +    };
>> +  };
>
> Uh.. where are the CPUs?
>

The number and type of CPUs can be (and is) probed.  There is an 
existing mechanism for the bootloader to communicate which CPUs should 
be used.

Likewise for memory, there is an existing mechanism for the bootloader 
to communicate which memory should be used.

It is possible that in the future, we would want to put CPUs and Memory 
in the Device Tree.  If we do, we can add that without having to disturb 
the 'soc' device bindings.

My main motivation for this first patch set is to get sane bindings for 
all the 'soc' devices  And to that end, your feedback has been quite useful.

Thanks,
David Daney
