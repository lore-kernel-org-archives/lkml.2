Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936735Ab0COUpu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Mar 2010 16:45:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:51662 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932138Ab0COUpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Mar 2010 16:45:45 -0400
Message-ID: <4B9E9B92.1040506@zytor.com>
Date: Mon, 15 Mar 2010 13:41:54 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.7) Gecko/20100120 Fedora/3.0.1-1.fc12 Thunderbird/3.0.1
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: David Miller <davem@davemloft.net>, drepper@redhat.com,
       ralf@linux-mips.org, linux-arch@vger.kernel.org,
       linux-kernel@vger.kernel.org, kernel@teksavvy.com,
       torvalds@linux-foundation.org, munroesj@linux.vnet.ibm.com
Subject: Re: 64-syscall args on 32-bit vs syscall()
References: <20100315134449.GB1653@linux-mips.org>	 <4B9E4EB1.9010800@zytor.com>	<4B9E59B7.6060405@redhat.com>	 <20100315.120004.209998642.davem@davemloft.net>	 <4B9E8D67.8040209@zytor.com> <1268685311.2335.38.camel@pasglop>
In-Reply-To: <1268685311.2335.38.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/15/2010 01:35 PM, Benjamin Herrenschmidt wrote:
> On Mon, 2010-03-15 at 12:41 -0700, H. Peter Anvin wrote:
>> I don't see why syscall() can't change the type for its first argument
>> -- it seems to be exactly what symbol versioning is for.
>>
>> Doesn't change the fact that it is fundamentally broken, of course. 
> 
> No need to change the type of the first arg and go for symbol
> versionning if you do something like I proposed earlier, there will be
> no conflict between syscall() and __syscall() and both variants can
> exist.
> 

Basically symbol versioning done "by hand", actually using symbol
versioning is better, IMNSHO.

	-hpa
