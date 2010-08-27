Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752817Ab0H0Ibw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Aug 2010 04:31:52 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:48788 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752463Ab0H0Ibu convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Aug 2010 04:31:50 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=mmqxq49CcY67pOo2xUIsCdbenQR9tTlIxNFbkUV3wj9C2DprIBfLw3d3IYXeEuQApU
         cyQBY+sTxDK0PbcPFLbXI4EZbyJ8PQaqozBoGt7WCaSoxlUrkBhZr62g2MT332kJVVgv
         Mif/mlkW8P9ovygt4aj6JNYhdAptoFuY0Vv8I=
MIME-Version: 1.0
In-Reply-To: <01b901cb45ab$39165480$3c64a8c0@newtouch.nt>
References: <1282882403-29824-1-git-send-email-skannan@codeaurora.org>
	<01b901cb45ab$39165480$3c64a8c0@newtouch.nt>
Date: Fri, 27 Aug 2010 16:31:49 +0800
Message-ID: <AANLkTi=hkgGBfGHnDAx0Sdb6YuJwF4wJyMdt=mnqefzx@mail.gmail.com>
Subject: Re: msgrcv() errno 514 ERESTARTNOHAND
From: Pei Lin <telent997@gmail.com>
To: =?GB2312?B?1uzOxLzR?= <wenjia.zhu@newtouch.cn>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=GB2312
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/8/27 ÖìÎÄ¼Ñ <wenjia.zhu@newtouch.cn>:
> Hello List£º
>
> ¡¡I have a problem with msgrcv().
>
>  I have used msgrcv() in my source to receive messages in a while(1).
>
>  But it returned an error in errno 514(ERESTARTNOHAND).
>
>  I search this error in net, and it seems to be should not happen in user
> program.
>
>  But it happened in my program, and once only. I didn't see it happens after
> that once.
>
>
>
>  My question is how can I make this error happen again?
>
> And how can I fix it?
>
>
>
> I saw RedHat has fixed the problem, but no details on their website.
>
http://rhn.redhat.com/errata/RHSA-2008-0612.html
the website had list the src rpm name. kernel-2.6.18-92.1.10.el5.src.rpm
you can use google to search the kernel src rpm and check the code changes.

>
>
> My OS is Montavista 5.0(Kernel2.6.18).
>
>
>
> Thanks
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>



-- 
Best Regards
Lin
