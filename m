Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932116Ab0D1TtN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Apr 2010 15:49:13 -0400
Received: from mail-yw0-f194.google.com ([209.85.211.194]:55070 "EHLO
	mail-yw0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932099Ab0D1TtL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Apr 2010 15:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=grJJgYHltsjIsnxp26OcSY4ndnwlA6BLatkeSF/VSr3MbsYOPRGUOq+UvNcZiNAufO
         djdd5FCK+6gTSmit5mMAahPOG+wkqgUeHcWur84yWFvv7ti3vfRxsdmD6XGTqDVeP1WF
         SSV3qP7qAiLBZfw9aM/PUgPSytzLd2hw4KAfw=
MIME-Version: 1.0
In-Reply-To: <20100428073912.f15206fa.akpm@linux-foundation.org>
References: <201004272115.o3RLFnKj020353@imap1.linux-foundation.org>
	 <l2l81b0412b1004280040t415657c7qe7de59f152cd49aa@mail.gmail.com>
	 <20100428073912.f15206fa.akpm@linux-foundation.org>
Date: Wed, 28 Apr 2010 21:49:10 +0200
Message-ID: <q2i81b0412b1004281249u69337d01le6d66c20e6eefceb@mail.gmail.com>
Subject: Re: [patch 1/1] sunrpc: use formatting of module name in SUNRPC
From: Alex Riesen <raa.lkml@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       trond.myklebust@fys.uio.no, linux-nfs@vger.kernel.org,
       Trond.Myklebust@netapp.com, cel@citi.umich.edu, davem@davemloft.net,
       tmtalpey@gmail.com
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 28, 2010 at 13:39, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 28 Apr 2010 09:40:36 +0200 Alex Riesen <raa.lkml@gmail.com> wrote:
>> > __net/sunrpc/xprt.c | __ __5 +----
>> > __1 file changed, 1 insertion(+), 4 deletions(-)
>> >
>>
>> This is one tough little patch... 2 years and counting...
>
> heh.  I've only had it since June '09.
>
> I'll merge it into 2.6.35-rc1.
>

That's because I was overly pessimistic. gcc-4.3.3 only exists since
24 Jan, 2009.
I just have the change (and other request_module name formatting patches)
in my trees already for quite some time...
