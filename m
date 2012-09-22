Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab2IVQVl (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Sep 2012 12:21:41 -0400
Received: from pegase1.c-s.fr ([93.17.236.30]:22779 "EHLO mailhub1.si.c-s.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752176Ab2IVQVk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Sep 2012 12:21:40 -0400
Message-ID: <505DE592.8060103@c-s.fr>
Date: Sat, 22 Sep 2012 18:21:38 +0200
From: leroy christophe <christophe.leroy@c-s.fr>
User-Agent: Mozilla/5.0 (Windows NT 5.1; rv:15.0) Gecko/20120907 Thunderbird/15.0.1
MIME-Version: 1.0
To: Lutz Jaenicke <ljaenicke@innominate.com>
CC: David S Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] lxt PHY: Support for the buggy LXT973 rev A2
References: <201209101545.q8AFjn7u021483@localhost.localdomain> <20120910181747.GA5960@lutz.bln.innominate.local>
In-Reply-To: <20120910181747.GA5960@lutz.bln.innominate.local>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Le 10/09/2012 20:17, Lutz Jaenicke a écrit :
> On Mon, Sep 10, 2012 at 05:45:49PM +0200, Christophe Leroy wrote:
>> This patch adds proper handling of the buggy revision A2 of LXT973 phy, adding
>> precautions linked to ERRATA Item 4:
>>
>> Item 4: MDIO Interface and Repeated Polling
>> Problem: Repeated polling of odd-numbered registers via the MDIO interface
>> 	randomly returns the contents of the previous even register.
>> Implication: Managed applications may not obtain the correct register contents
>> 	when a particular register is monitored for device status.
>> Workaround: None.
>> Status: This erratum has been previously fixed (in rev A3)
> Hmm. Were did you get the hardware from? We have been using LXT973 in
> our products and the A2 was replaced by A3 in 2003.
>
> Best regards,
> 	Lutz
They are custom boards that my company manufactures. Most boards 
manufactured before 2006 or 2007 have this buggy chip.

Regards
Christophe
