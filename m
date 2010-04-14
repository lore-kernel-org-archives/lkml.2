Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756890Ab0DNV7E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Apr 2010 17:59:04 -0400
Received: from mail-bw0-f209.google.com ([209.85.218.209]:43209 "EHLO
	mail-bw0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753942Ab0DNV7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Apr 2010 17:59:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type;
        b=u+nzoHVNy1n3rBteUymdz6FYtRNZPtGjYCC/+WyQOhsvRetv3sNP1Uk3nhqxsrv1G/
         +JsfS/IeVE+ukUZQ22s604UnlM37sXxnjambskp+U/Nn2FqGsEIRf+B5U8lZ09tjLsMV
         btUQ6nE56DMcP2FrUqQLosYnsTUoSf9xhP8w4=
MIME-Version: 1.0
In-Reply-To: <20100414152231.GA16779@a1.tnic>
References: <alpine.DEB.2.00.1004132147260.1881@parag-laptop>
	 <20100414061746.GA23153@liondog.tnic>
	 <alpine.LFD.2.00.1004140712240.15116@i5.linux-foundation.org>
	 <20100414152231.GA16779@a1.tnic>
Date: Wed, 14 Apr 2010 17:58:57 -0400
Message-ID: <l2yf7848161004141458k5ff49eefs4c1871e2157df9d5@mail.gmail.com>
Subject: Re: 2.6.34-rc4 : OOPS in unmap_vma
From: Parag Warudkar <parag.lkml@gmail.com>
To: Borislav Petkov <bp@alien8.de>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org,
       Vivek Goyal <vgoyal@redhat.com>, Haren Myneni <hbabu@us.ibm.com>,
       kexec@lists.infradead.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Borislav

On Wed, Apr 14, 2010 at 11:22 AM, Borislav Petkov <bp@alien8.de> wrote:

> interesting what he means there - a kexec-enabled kernel or is this the
> "second" kernel his machine kexec'd into after a previous failure. I
> think this could clarify the situation a bit.
>

It was the kexec'ed kernel that oopsed - the first kernel had no issues.
It was kexec'ing from 2.6.34-rc4 to the same kernel.

After that I have tried to reboot via kexec to try to reproduce the
issue but it either hung completely or resulted in corrupted X and
non-moving cursor.
Kexec from Distro kernel to itself works just fine (Ubuntu 2.6.32-20) however.

I will start a bisect as soon as find time.

Parag
