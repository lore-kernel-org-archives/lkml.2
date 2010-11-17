Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935313Ab0KQS7j (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:59:39 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:59959 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935040Ab0KQS7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:59:38 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=UNtl/8zw3kC0v9VnEFIcjjfz9Rbq1RNJLX70KmnXwD6fYc4S/NOoXCZZCL/BicGCO8
         ROp/CXJzCpXL3unjxoJXCgA4TeYY+8w/yYuhekH15ywEsJAZt3A+p+FzNDHF3Ealvxd/
         IK4cy+jhSs420Guz2Dfda7xMEDtPoA5QwA0tw=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=xywyAOZzf4DwoP/zZ6Vd2MdBYTIUkZN1bYB5JPwTVXbuimYhrYF5kubiMPdNe4xceU
         bCK7TW5OyEtUBDVxTg/yjsveyPOF+C4/ejACE92JK1P2YSmM4gb1BqvN0UGmJXeyis/p
         gq387YhoNvjyWeUuRUQ8hRlDTO1aHErlqjERU=
MIME-Version: 1.0
In-Reply-To: <AANLkTi=3nDO7QtezcoOyimPvXqLBgxtO18HjjuT_6WKb@mail.gmail.com>
References: <1290018947.4887.14.camel@note-311a>
	<AANLkTi=3nDO7QtezcoOyimPvXqLBgxtO18HjjuT_6WKb@mail.gmail.com>
Date: Wed, 17 Nov 2010 19:59:33 +0100
Message-ID: <AANLkTikWoamBm=XOuJ41NShTrYBUgNLaZQbp2C-R+Hxw@mail.gmail.com>
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
