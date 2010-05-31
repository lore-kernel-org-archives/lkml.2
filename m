Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0EaS4N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 May 2010 14:56:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:46869 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756876Ab0EaS4M (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 May 2010 14:56:12 -0400
Message-ID: <4C040636.8060702@redhat.com>
Date: Mon, 31 May 2010 20:55:50 +0200
From: Milan Broz <mbroz@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100317 Lightning/1.0b1 Thunderbird/3.0.4
MIME-Version: 1.0
To: Andi Kleen <andi@firstfloor.org>
CC: device-mapper development <dm-devel@redhat.com>,
       herbert@gondor.hengli.com.au, linux-kernel@vger.kernel.org,
       agk@redhat.com, ak@linux.intel.com
Subject: Re: [dm-devel] [PATCH] DM-CRYPT: Scale to multiple CPUs
References: <20100531160425.GA20344@basil.fritz.box> <4C03F04D.4040200@redhat.com> <20100531174225.GE10766@basil.fritz.box> <4C03FB8E.1060109@redhat.com> <20100531182724.GG10766@basil.fritz.box>
In-Reply-To: <20100531182724.GG10766@basil.fritz.box>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/31/2010 08:27 PM, Andi Kleen wrote:

>>> AES-NI is not asynchronous and doesn't have limited resources.
>>
>> AES-NI used asynchronous crypto interface, was using asynchronous
>> crypto API cryptd daemon IIRC. So this changed?
> 
> AFAIK all ciphers use the asynchronous interface,  but that 
> doesn't mean they are actually asynchronous. AES-NI certainly
> does not require running in a special thread. The only
> thing it doesn't support is running from interrupt context.

I mean how it is implemented now in crypto API, and I was almost
sure that aes-ni acceleration code uses cryptd (iow real asynchronous processing)
and also that not all CPU cores can run these instruction in parallel.

So I am mistaken here?

Milan
