Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752452Ab0LCPqM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Dec 2010 10:46:12 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:37513 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751045Ab0LCPqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Dec 2010 10:46:11 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=DWCU0SUBRpXuZECEd/9UGxpwfoh3iCrH3074cS8DoRX1DvrUXO9ALteAZKDxystahm
         3ASTAY/Mide6YGl27o2fPYNUe74vAut8FzmWBaAml1Rd0a19sTXfj5e0LfIZVbKBDKcs
         0wySF8JXRZnnhTWNZjOqud6Q8wy2lXI97l5Gk=
MIME-Version: 1.0
In-Reply-To: <20101203111623.GA2741@redhat.com>
References: <20101203111623.GA2741@redhat.com>
Date: Fri, 3 Dec 2010 18:46:09 +0300
Message-ID: <AANLkTi=Xvbi5M_cNRL=wC+uwksG08SiCyWcqdmwB_5TU@mail.gmail.com>
Subject: Re: kdump broken on 2.6.37-rc4
From: Maxim Uvarov <muvarov@gmail.com>
To: Stanislaw Gruszka <sgruszka@redhat.com>
Cc: kexec@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2010/12/3 Stanislaw Gruszka <sgruszka@redhat.com>:
> On my T-60 laptop, i686 system with 2.6.37-rc4 kernel,
> "echo c > /proc/sysrq-trigger" just hung the system. Kdump
> works on 2.6.36. Is this known issue? If not, what info
> I should provide to solve it (I think the easiest way
> to solve the problem would be bisect) ?
>
> Stanislaw
>

I tested x86 QEMU yesterday with the latest git. It worked.
Might be something target specific.., What does console print?

> _______________________________________________
> kexec mailing list
> kexec@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/kexec
>



-- 
Best regards,
Maxim Uvarov
