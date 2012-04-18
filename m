Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754277Ab2DRQY7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Apr 2012 12:24:59 -0400
Received: from mail3.caviumnetworks.com ([12.108.191.235]:4227 "EHLO
	mail3.caviumnetworks.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab2DRQY6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Apr 2012 12:24:58 -0400
Message-ID: <4F8EEAD8.8050205@cavium.com>
Date: Wed, 18 Apr 2012 09:24:56 -0700
From: David Daney <david.daney@cavium.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: ddaney.cavm@gmail.com, grant.likely@secretlab.ca, rob.herring@calxeda.com,
        devicetree-discuss@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-mips@linux-mips.org,
        afleming@gmail.com, galak@kernel.crashing.org
Subject: Re: [PATCH v4 3/3] netdev/of/phy: Add MDIO bus multiplexer driven
 by GPIO lines.
References: <1334683966-12112-1-git-send-email-ddaney.cavm@gmail.com>	<1334683966-12112-4-git-send-email-ddaney.cavm@gmail.com> <20120417.225308.1588669089502246200.davem@davemloft.net>
In-Reply-To: <20120417.225308.1588669089502246200.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 18 Apr 2012 16:24:57.0179 (UTC) FILETIME=[CB4262B0:01CD1D7F]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/17/2012 07:53 PM, David Miller wrote:
> From: David Daney<ddaney.cavm@gmail.com>
> Date: Tue, 17 Apr 2012 10:32:46 -0700
>
>> From: David Daney<david.daney@cavium.com>
>>
>> The GPIO pins select which sub bus is connected to the master.
>>
>> Initially tested with an sn74cbtlv3253 switch device wired into the
>> MDIO bus.
>>
>> Signed-off-by: David Daney<david.daney@cavium.com>
>
> Are you sure the Kconfig dependencies are sufficient?  This code seems
> to depend upon OF, and in particular the OF_MDIO stuff.
>

You are correct.  Should I:

A) Create a patch to fix the dependencies it on top of the previous set?

B) Regenerate the entire set with said patch rolled in?

Thanks,
David Daney
