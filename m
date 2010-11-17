Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935297Ab0KQS6i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Nov 2010 13:58:38 -0500
Received: from mail-vw0-f46.google.com ([209.85.212.46]:58280 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935040Ab0KQS6g convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Nov 2010 13:58:36 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=dkim-signature:domainkey-signature:mime-version:in-reply-to
         :references:date:message-id:subject:from:to:cc:content-type
         :content-transfer-encoding;
        b=pBrtkgvyUC5ghjrKD5X0rEzpJHM3cQDBF1UPC/IjJkOUmPc3Z9L+xtL3SbEMFp27rW
         avF+938Hw5W45T7Way0u4qc4g1wcCVzjn2wPjzQCcLjjJWR1VTT/blPUDy8WzFFLQEjW
         NDlrtOYm9wfejBN3L2LFCxjU43rdGS2FwI0nU=
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=FwYb3gCjf8LJwD8eEXw5y+9HJMRCmEW36IcA+HsV0WvF2O4kQZHExyd3cIhd9wiqIt
         VvvqrRO32Dv1TxqdmrupEVZVzLiX5yPytea6gwU/wzJy2C/WdR7mbjFfobiCRr270/oX
         B1ilNMBlSZUIP9f3A1SWhlW2KMDRFmZcQqYZw=
MIME-Version: 1.0
In-Reply-To: <1290018947.4887.14.camel@note-311a>
References: <1290018947.4887.14.camel@note-311a>
Date: Wed, 17 Nov 2010 19:58:34 +0100
Message-ID: <AANLkTi=3nDO7QtezcoOyimPvXqLBgxtO18HjjuT_6WKb@mail.gmail.com>
Subject: Re: Galbraith patch
From: Dhaval Giani <dhaval.giani@gmail.com>
To: gilberto.nunes@selbetti.com.br, Mike Galbraith <efault@gmx.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[CC'ing Mike]

On Wed, Nov 17, 2010 at 7:35 PM, Gilberto Nunes
<gilberto.nunes@selbetti.com.br> wrote:
> Hi folks...
>
> That is my first post...
> I tried compile a vanilla kernel with Galbraith patch, but without
> sucess...
> When I turn on "Automatic process group scheduling" and try to compile
> the kernel, I get this error:
>
> kernel/sched.c: In function ‘sched_init’:
> kernel/sched.c:7756: error: implicit declaration of function
> ‘autogroup_init’
> make[1]: ** [kernel/sched.o] Erro 1
> make: ** [kernel] Erro 2
>
>
> Someone know what is wrong here??
>
> Thanks for any help!
>
> Regards
>
