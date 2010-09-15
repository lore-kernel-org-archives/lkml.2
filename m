Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529Ab0IOBeI (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Sep 2010 21:34:08 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:60659 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751426Ab0IOBeG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Sep 2010 21:34:06 -0400
Message-ID: <4C90226E.4050306@kernel.org>
Date: Tue, 14 Sep 2010 18:33:34 -0700
From: Yinghai Lu <yinghai@kernel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.11) Gecko/20100714 SUSE/3.0.6 Thunderbird/3.0.6
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>
CC: Ingo Molnar <mingo@elte.hu>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        ppc-dev <linuxppc-dev@lists.ozlabs.org>
Subject: Re: linux-next: build warnings after merge of the final tree (tip
 treee related)
References: <20100913132721.5a02cfbc.sfr@canb.auug.org.au>	<4C8DA517.9000603@kernel.org>	<20100913143942.7344ada4.sfr@canb.auug.org.au>	<4C8DDFB4.1020508@kernel.org>	<20100914145025.977ec2a6.sfr@canb.auug.org.au>	<4C8FFE76.8070801@kernel.org> <20100915102930.5e4d59cb.sfr@canb.auug.org.au>
In-Reply-To: <20100915102930.5e4d59cb.sfr@canb.auug.org.au>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/14/2010 05:29 PM, Stephen Rothwell wrote:
> Hi Yinghai,
> 
> On Tue, 14 Sep 2010 16:00:06 -0700 Yinghai Lu <yinghai@kernel.org> wrote:
>>
>> Also, we may need to remove all extern and __init and __initdata etc in .h files.
> 
> Do not remove the "extern" key word.
> 

why? you got another warning?

Yinghai
