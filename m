Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754721Ab1IFOcJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 10:32:09 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33462 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753795Ab1IFOcD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 10:32:03 -0400
MIME-Version: 1.0
In-Reply-To: <1314880595.1439.13.camel@deneb.redhat.com>
References: <1314826214-22428-1-git-send-email-msalter@redhat.com>
 <1314826214-22428-2-git-send-email-msalter@redhat.com> <CAHXqBFJ6tEkn+iW3ZBAiWu5Sx9y9MQdnJt5Gfnv5Xc3UB78uLw@mail.gmail.com>
 <1314880595.1439.13.camel@deneb.redhat.com>
From: Catalin Marinas <catalin.marinas@arm.com>
Date: Tue, 6 Sep 2011 15:30:42 +0100
X-Google-Sender-Auth: kLOFRdomzBJDi1eCTx-l-ySdB70
Message-ID: <CAHkRjk7QWCkKKT8BErRsS_ZASChOyGuh04PM2qP3pQnp+KhJVw@mail.gmail.com>
Subject: Re: [PATCH 1/3] add dma_coherent_write_sync to DMA API
To: Mark Salter <msalter@redhat.com>
Cc: =?ISO-8859-2?Q?Micha=B3_Miros=B3aw?= <mirqus@gmail.com>,
        ming.lei@canonical.com, stern@rowland.harvard.edu,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(coming late to this thread due to holidays)

2011/9/1 Mark Salter <msalter@redhat.com>:
> On Thu, 2011-09-01 at 11:57 +0200, Michał Mirosław wrote:
>> BTW, if there's no time limit on write buffers flushing, or if write
>> buffers can cause reordering of the writes, then the memory accesses
>> need to be managed just like non-DMA-coherent memory. So what differs
>> then in DMA-coherent vs non-DMA-coherent mappings then?
>
> My understanding is that ordering is preserved, but an ARM guy should
> probably verify that.

On ARMv6 onwards the coherent DMA is Normal Non-cacheable memory and
this is buffered and can be reordered.

-- 
Catalin
