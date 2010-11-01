Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757981Ab0KANmo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 09:42:44 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:46443 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757955Ab0KANmk convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 09:42:40 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=odeGprPnWvuE0+rUKvbRDLXFtNaQlwL/xXeDYeGuSUMgr/SdoJx+OmgXhPYBF9xfRJ
         E4dD8ucx0fqAUJRkygtjPhCq+83eO/b5AWZ9uHxhgX/OJoB9UzQaX83DQJxQMfIqVvbT
         FSunrslD/ptOXs/X4k79J905MNsZi4Td2KJkM=
MIME-Version: 1.0
In-Reply-To: <20101101095922.GE6023@cr0.nay.redhat.com>
References: <AANLkTikfW7QfXX76JM=pDYuQYexPvQz3hrAE=B3YMD5x@mail.gmail.com>
	<20101101092947.GB6023@cr0.nay.redhat.com>
	<AANLkTi=vF50JAFQRMWRDKpbk157amaXpDetna=8==pHn@mail.gmail.com>
	<AANLkTikkh+Pif7DuP3p-fH2=5_otX7N0NSjSB2h13yFC@mail.gmail.com>
	<20101101095922.GE6023@cr0.nay.redhat.com>
Date: Mon, 1 Nov 2010 21:42:39 +0800
Message-ID: <AANLkTi=_iawjarxDF8wghrmN4uZ4oFNYeX_K-sqk0ZBO@mail.gmail.com>
Subject: Re: How many params can be accept by kernel module at most?
From: tingwei liu <tingw.liu@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/11/1 Américo Wang <xiyou.wangcong@gmail.com>:
> On Mon, Nov 01, 2010 at 05:49:53PM +0800, tingwei liu wrote:
>>The params are transferred by command line. And the params are all in
>>program statically. So the stack size determine the params number. For
>>example: stack size is 4K,and params are unsigned int type with 4
>>bytes,so the max number of params is 1 thousand。
>>
>
> Please don't top-reply.
>
> That is not true, the parameters are passed via 'uargs' of init_module()
> dynamically, this is when you invoke modprobe/insmod.
>
> For your own kernel module, you may use module_param() to provide
> parameters, the max of this is limited to the size of ELF section size,
> since they are stored in "__param" section.
>

I really use module_param() to provide parameters. How much of the ELF
section size? How can I find the document of the ELF.
