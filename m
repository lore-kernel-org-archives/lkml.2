Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752156Ab0EFVXu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 17:23:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52669 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750967Ab0EFVXt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 17:23:49 -0400
Message-ID: <4BE3334A.1010507@zytor.com>
Date: Thu, 06 May 2010 14:23:22 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100330 Fedora/3.0.4-1.fc12 Thunderbird/3.0.4
MIME-Version: 1.0
To: Greg KH <greg@kroah.com>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       x86@kernel.org, linux-kernel@vger.kernel.org,
       Vadim Rozenfeld <vrozenfe@redhat.com>, Avi Kivity <avi@redhat.com>,
       Gleb Natapov <gleb@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
       Haiyang Zhang <haiyangz@microsoft.com>,
       Hank Janssen <hjanssen@microsoft.com>
Subject: Re: [PATCH] x86: detect running on a HyperV system
References: <20100506190841.GA1605@kroah.com> <4BE314CD.6060701@zytor.com> <20100506191816.GA20874@kroah.com>
In-Reply-To: <20100506191816.GA20874@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/06/2010 12:18 PM, Greg KH wrote:
>>
>> I'd prefer to take it in -tip, partly because I would like to rework a
>> few things -- including preexisting braindamage like c->x86_hyper_vendor
>> (since when was hypervisor vendor a per-cpu property!?)
> 
> Heh, good point, but where should it live?
> 

Probably just make it a global variable, or somesuch.

	-hpa
