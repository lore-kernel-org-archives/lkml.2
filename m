Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756963Ab0KAJt4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Nov 2010 05:49:56 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49992 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0KAJty convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Nov 2010 05:49:54 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=QZnpF+SqfBb+loT3XoWE8tuvWHWnRdYxAYqm68MKwfYKXUogLlsjHNRy+69420G8Vm
         jQB0xHmnYMnm1lo35cm3LEE44zr0UDNcmH5nl6bs4d/XXFq2EeYeKHvMLdbZanGGhiCD
         ZelMG1r1svhV54sw0aZAoLAr6IDoyanI5uiTg=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=vF50JAFQRMWRDKpbk157amaXpDetna=8==pHn@mail.gmail.com>
References: <AANLkTikfW7QfXX76JM=pDYuQYexPvQz3hrAE=B3YMD5x@mail.gmail.com>
	<20101101092947.GB6023@cr0.nay.redhat.com>
	<AANLkTi=vF50JAFQRMWRDKpbk157amaXpDetna=8==pHn@mail.gmail.com>
Date: Mon, 1 Nov 2010 17:49:53 +0800
Message-ID: <AANLkTikkh+Pif7DuP3p-fH2=5_otX7N0NSjSB2h13yFC@mail.gmail.com>
Subject: Re: How many params can be accept by kernel module at most?
From: tingwei liu <tingw.liu@gmail.com>
To: =?UTF-8?Q?Am=C3=A9rico_Wang?= <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The params are transferred by command line. And the params are all in
program statically. So the stack size determine the params number. For
example: stack size is 4K,and params are unsigned int type with 4
bytes,so the max number of params is 1 thousand。

2010/11/1 tingwei liu <tingw.liu@gmail.com>:
> What's the meaning of dynamically and statically?
> You response help me much. Thank you
>
> 2010/11/1 Américo Wang <xiyou.wangcong@gmail.com>:
>> On Mon, Nov 01, 2010 at 02:17:23PM +0800, tingwei liu wrote:
>>>How many params can be accept by kernel module at most?
>>
>> If you mean dynamically, these parameters are passed as a whole to kernel,
>> from the source code, you can see the max length is ~0UL>>1.
>>
>> If you mean statically, IOW, the max paramenters you can provide in your module,
>> this is limited by ELF section size.
>>
>> Hope this helps.
>>
>
