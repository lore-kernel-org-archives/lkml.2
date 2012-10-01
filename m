Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758254Ab2JAXQY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 19:16:24 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:36797 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1758213Ab2JAXQT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 19:16:19 -0400
Message-ID: <506A2439.2050408@xenotime.net>
Date: Mon, 01 Oct 2012 16:16:09 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Ohad Ben-Cohen <ohad@wizery.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: Tree for Sept 24 (remoteproc)
References: <20120925005328.f748dfa3d077cebb345a4291@canb.auug.org.au> <5060DA6B.3030806@xenotime.net>
In-Reply-To: <5060DA6B.3030806@xenotime.net>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/24/2012 03:10 PM, Randy Dunlap wrote:

> On 09/24/2012 07:53 AM, Stephen Rothwell wrote:
> 
>> Hi all,
>>
>> Today was a train wreck, with lots of new conflicts across several trees
>> and a few build failures as well.
>>
>> Changes since 201209021:
>>
> 


This build still fails on linux-next of 20121001 when
VIRTIO is not enabled.

> 
> on x86_64:
> 
> drivers/built-in.o: In function `rproc_virtio_finalize_features':
> remoteproc_virtio.c:(.text+0x2f9a02): undefined reference to `vring_transport_features'
> drivers/built-in.o: In function `rproc_virtio_del_vqs':
> remoteproc_virtio.c:(.text+0x2f9a74): undefined reference to `vring_del_virtqueue'
> drivers/built-in.o: In function `rproc_virtio_find_vqs':
> remoteproc_virtio.c:(.text+0x2f9c44): undefined reference to `vring_new_virtqueue'
> drivers/built-in.o: In function `rproc_add_virtio_dev':
> (.text+0x2f9e2c): undefined reference to `register_virtio_device'
> drivers/built-in.o: In function `rproc_vq_interrupt':
> (.text+0x2f9db7): undefined reference to `vring_interrupt'
> drivers/built-in.o: In function `rproc_remove_virtio_dev':
> (.text+0x2f9e9f): undefined reference to `unregister_virtio_device'
> 
> 
> Full randconfig file is attached.
> 
> 
> 



-- 
~Randy
