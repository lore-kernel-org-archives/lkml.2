Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756153Ab0KAJc6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:32:58 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:54630 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755523Ab0KAJcz convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:32:55 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=oAsNK+FRDB4r/2vrLmEevfxVAGxgdrTFDqg6jK3pL2OE+VSjIzNv57Exc+gCDRgJCi
         eYAiZJ2AIKkl7dN2KQP2XzE7sfhQspAiEnXGX4rzExgS51MscT+79eZVZSth069ea4eQ
         RXYyo8xSv9eQJRkYakRyimKCZWuK52gsnots0=
MIME-Version: 1.0
In-Reply-To: <20101101092947.GB6023@cr0.nay.redhat.com>
References: <AANLkTikfW7QfXX76JM=pDYuQYexPvQz3hrAE=B3YMD5x@mail.gmail.com>
	<20101101092947.GB6023@cr0.nay.redhat.com>
Date: Mon, 1 Nov 2010 17:32:55 +0800
Message-ID: <AANLkTi=vF50JAFQRMWRDKpbk157amaXpDetna=8==pHn@mail.gmail.com>
Subject: Re: How many params can be accept by kernel module at most?
From: tingwei liu <tingw.liu@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What's the meaning of dynamically and statically?
You response help me much. Thank you

2010/11/1 Américo Wang <xiyou.wangcong@gmail.com>:
> On Mon, Nov 01, 2010 at 02:17:23PM +0800, tingwei liu wrote:
>>How many params can be accept by kernel module at most?
>
> If you mean dynamically, these parameters are passed as a whole to kernel,
> from the source code, you can see the max length is ~0UL>>1.
>
> If you mean statically, IOW, the max paramenters you can provide in your module,
> this is limited by ELF section size.
>
> Hope this helps.
>
