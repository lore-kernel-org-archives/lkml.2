Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935336Ab0KQTAb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 14:00:31 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:48534 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935040Ab0KQTAa convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 14:00:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=GWuSl27fUGC2RbX024x7yIwocdWAp5ptmWWarXOxJ50iT8LThmNwlCRSmEoKGJWcjD
         qPBfylMyyvUTdDCdK0T4rJYs7bMKOm08hqAzbR9VYOKNkhpCnxw8J1VFrywJwcvWpi6H
         v6rEllUKsYvnd0alqsOVAz6BsX3cOoqheYvZY=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=x6vBZBZFUQuWNGyc/fdArDJaGCmoZC/7Tbl7RU7y/WB2Th+LHgmGtf9iRzlIRQcnti
         X7bK1hbi2XeuhaaK8z+PLJkGxYQICfcdTIoDs7JrUWAfAxrCFw6jSJvx7jTPKBOwJXcf
         SVOeamhXHHAKNDYxhy4K0HjohmYmscCsJa31E=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=3nDO7QtezcoOyimPvXqLBgxtO18HjjuT_6WKb@mail.gmail.com>
References: <1290018947.4887.14.camel@note-311a>
	<AANLkTi=3nDO7QtezcoOyimPvXqLBgxtO18HjjuT_6WKb@mail.gmail.com>
Date: Wed, 17 Nov 2010 20:00:27 +0100
Message-ID: <AANLkTinRBvZQmeU-eEeDSd1ELvcxDZAdM6F8-UCROybq@mail.gmail.com>
Subject: Re: Galbraith patch
From: Dhaval Giani <dhaval.giani@gmail.com>
To: gilberto.nunes@selbetti.com.br, Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 17, 2010 at 7:58 PM, Dhaval Giani <dhaval.giani@gmail.com> wrote:
> [CC'ing Mike]
>
> On Wed, Nov 17, 2010 at 7:35 PM, Gilberto Nunes
> <gilberto.nunes@selbetti.com.br> wrote:
>> Hi folks...
>>
>> That is my first post...
>> I tried compile a vanilla kernel with Galbraith patch, but without
>> sucess...
>> When I turn on "Automatic process group scheduling" and try to compile
>> the kernel, I get this error:
>>
>> kernel/sched.c: In function ‘sched_init’:
>> kernel/sched.c:7756: error: implicit declaration of function
>> ‘autogroup_init’
>> make[1]: ** [kernel/sched.o] Erro 1
>> make: ** [kernel] Erro 2
>>
>>
>> Someone know what is wrong here??
>>

Could you send your .config as well?

Thanks,
Dhaval
