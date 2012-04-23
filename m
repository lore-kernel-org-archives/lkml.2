Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754309Ab2DWQln (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Apr 2012 12:41:43 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61442 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752488Ab2DWQll (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Apr 2012 12:41:41 -0400
Message-ID: <4F958641.7070708@gmail.com>
Date: Mon, 23 Apr 2012 09:41:37 -0700
From: David Daney <ddaney.cavm@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.15) Gecko/20101027 Fedora/3.0.10-1.fc12 Thunderbird/3.0.10
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: david.s.daney@gmail.com, ddaney.cavm@gmail.com, grant.likely@secretlab.ca,
        rob.herring@calxeda.com, devicetree-discuss@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-mips@linux-mips.org, afleming@gmail.com,
        galak@kernel.crashing.org
Subject: Re: [PATCH v5 2/3] netdev/of/phy: Add MDIO bus multiplexer support.
References: <1334791254-15987-3-git-send-email-ddaney.cavm@gmail.com>	<20120421.153201.2103447307695063734.davem@davemloft.net>	<4F9325DF.7020003@gmail.com> <20120421.190335.1197591560590885057.davem@davemloft.net>
In-Reply-To: <20120421.190335.1197591560590885057.davem@davemloft.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/21/2012 04:03 PM, David Miller wrote:
> From: David Daney<david.s.daney@gmail.com>
> Date: Sat, 21 Apr 2012 14:25:51 -0700
>
>> If we were to specify the dependencies in both places, we gain nothing
>> other than duplication of information.
>
> Each Kconfig option enabling a module has to have appropriate
> dependencies.
>
I will send a revised patch set.

Thanks,
David Daney
