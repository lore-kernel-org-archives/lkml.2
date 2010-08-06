Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933499Ab0HFFLo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Aug 2010 01:11:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:52226 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751623Ab0HFFLm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Aug 2010 01:11:42 -0400
Message-ID: <4C5B965F.4020109@kernel.org>
Date: Thu, 05 Aug 2010 21:58:07 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: David Miller <davem@davemloft.net>, akpm@linux-foundation.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [GIT] Networking
References: <20100803.203814.59697285.davem@davemloft.net> 	<AANLkTimxv1y3QJ7s+ghi1FFCcwnUVWT1n6dvT-NNN=Oo@mail.gmail.com> 	<AANLkTinU4+tcm2O_BVBFkHSdnx7JEPtM4sw_s--qdUKC@mail.gmail.com> <AANLkTi=3dVWKtgL2A=4xm_1VSk64--3Zk_fQBYUdAAn+@mail.gmail.com>
In-Reply-To: <AANLkTi=3dVWKtgL2A=4xm_1VSk64--3Zk_fQBYUdAAn+@mail.gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8bit
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A090201.4C5B9963.0166,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/05/2010 07:15 PM, Linus Torvalds wrote:
> On Thu, Aug 5, 2010 at 7:04 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>>
>>  CC      drivers/net/ixgbe/ixgbe_main.o
>> drivers/net/ixgbe/ixgbe_main.c: In function ‘ixgbe_select_queue’:
>> drivers/net/ixgbe/ixgbe_main.c:6159: error: ‘struct ixgbe_fcoe’ has no member named ‘up’
> 
> Hmm. You must have some other version of that file than I do. Line
> 6159 is in ixgbe_init_module() in my source tree.
> 

http://patchwork.ozlabs.org/patch/60777/

Yinghai
