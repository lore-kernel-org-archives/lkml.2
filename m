Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753412Ab1C2Oam (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:30:42 -0400
Received: from e24smtp01.br.ibm.com ([32.104.18.85]:40369 "EHLO
	e24smtp01.br.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752711Ab1C2Oal (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:30:41 -0400
Message-ID: <4D91ED0C.8070503@linux.vnet.ibm.com>
Date: Tue, 29 Mar 2011 11:30:36 -0300
From: Rajiv Andrade <srajiv@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Stefan Berger <stefanb@linux.vnet.ibm.com>
CC: Jeff Layton <jlayton@poochiereds.net>, linux-kernel@vger.kernel.org,
        tpmdd-devel@lists.sourceforge.net,
        "debora@linux.vnet.ibm.com" <debora@linux.vnet.ibm.com>
Subject: Re: TPM chip prevents machine from suspending
References: <20110328100846.0ba2e039@tlielax.poochiereds.net> <4D90C472.3090908@linux.vnet.ibm.com> <20110328141241.06a435f8@tlielax.poochiereds.net> <20110328154543.1bb979fd@tlielax.poochiereds.net> <4D91157F.2020502@linux.vnet.ibm.com> <20110329080856.1726dfaa@tlielax.poochiereds.net> <4D91CF9D.3050500@linux.vnet.ibm.com>
In-Reply-To: <4D91CF9D.3050500@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11032914-6842-0000-0000-0000013EFE72
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/29/2011 09:25 AM, Stefan Berger wrote:
> On 03/29/2011 08:08 AM, Jeff Layton wrote:
>> >> Is there some way short of recompiling with CONFIG_TCG_* turned off
>> to disable the TPM driver at boot time?
>>
> As far as I know, 'no'. I'd defer it to the maintainers as to how they would want to solve your particular problem... either by using above work-around, which would be more transparent, or actively having to turn the driver off with a command line parameter.
> 
>    Stefan
> 

I'm handling a patch from Stefan that solves so, for now, 
I'd recommend to use Stefan's tool.

Thanks,
Rajiv

