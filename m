Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173Ab1G2LTs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Jul 2011 07:19:48 -0400
Received: from mail-gx0-f174.google.com ([209.85.161.174]:38051 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756467Ab1G2LTq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Jul 2011 07:19:46 -0400
Message-ID: <4E32974B.6060605@gmail.com>
Date: Fri, 29 Jul 2011 19:19:39 +0800
From: Liu Yuan <namei.unix@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110617 Thunderbird/3.1.11
MIME-Version: 1.0
To: Christoph Hellwig <hch@infradead.org>
CC: "Michael S. Tsirkin" <mst@redhat.com>,
        Rusty Russell <rusty@rustcorp.com.au>, Avi Kivity <avi@redhat.com>,
        kvm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] vhost-blk: An in-kernel accelerator for virtio-blk
References: <1311863346-4338-1-git-send-email-namei.unix@gmail.com> <1311863346-4338-2-git-send-email-namei.unix@gmail.com> <20110728144740.GA26744@infradead.org>
In-Reply-To: <20110728144740.GA26744@infradead.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/28/2011 10:47 PM, Christoph Hellwig wrote:
> On Thu, Jul 28, 2011 at 10:29:05PM +0800, Liu Yuan wrote:
>> From: Liu Yuan<tailai.ly@taobao.com>
>>
>> Vhost-blk driver is an in-kernel accelerator, intercepting the
>> IO requests from KVM virtio-capable guests. It is based on the
>> vhost infrastructure.
>>
>> This is supposed to be a module over latest kernel tree, but it
>> needs some symbols from fs/aio.c and fs/eventfd.c to compile with.
>> So currently, after applying the patch, you need to *recomplie*
>> the kernel.
>>
>> Usage:
>> $kernel-src: make M=drivers/vhost
>> $kernel-src: sudo insmod drivers/vhost/vhost_blk.ko
>>
>> After insmod, you'll see /dev/vhost-blk created. done!
> You'll need to send the changes for existing code separately.
>
Thanks for reminding.

> If you're going mostly for raw blockdevice access just calling
> submit_bio will shave even more overhead off, and simplify the
> code a lot.
Yes, sounds cool, I'll give it a try.

Yuan
