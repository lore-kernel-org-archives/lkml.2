Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757362Ab0HNXaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 19:30:23 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:51517 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756155Ab0HNXaV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 19:30:21 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=EuVQNArVQcN+v4qLnowpe4gsDutJ2ME1UcVMXrdWPDF/GjCku1YkjmOmCK35iaycMp
         h7ewG8FyPm8h1GhOVKH7fImkfFdHhfgRThHeTCtIPvTXeCvKowj7A1sjTGC7HkqJ1t60
         H82x+vBQJeH/jSqtlaSN0Zr7few092Iujx4y0=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <20100815002726.698a1364@neptune.home>
References: <AANLkTikMnW2PfMAQdJKtDGPYeqkev7aJiDMUp6CBznm4@mail.gmail.com>
	<20100815002726.698a1364@neptune.home>
Date: Sun, 15 Aug 2010 01:30:21 +0200
Message-ID: <AANLkTimSLba3Ob2rrtFBga-eazTPQYGwnYZu+t+6Cv_X@mail.gmail.com>
Subject: Re: 2.6.36-git: BUG in highmem_32.c:45 causing scheduling while atomic
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: =?UTF-8?Q?Bruno_Pr=C3=A9mont?= <bonbons@linux-vserver.org>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Aug 15, 2010 at 12:27 AM, Bruno Prémont
<bonbons@linux-vserver.org> wrote:
> On Sat, 14 August 2010 Sedat Dilek <sedat.dilek@googlemail.com> wrote:
>> Looks like another side-effect of BR #16588 to me?
>>
>> Can you try the revert-patches attached to [1], re-compile and give feedback?
>>
>> - Sedat -
>>
>> [1] https://bugzilla.kernel.org/show_bug.cgi?id=16588
>
> Linus's fixup patch (from "Linux 2.6.35.2" thread, committed as
> "mm: fix page table unmap for stack guard page properly",
> 11ac552477e32835cb6970bf0a70c210807f5673) seems to fix it as well.
>

Yes, that is the "official" fix in upstream, fixes also issues in 2.6.35.2.
The BR #16588 got diverse informations and fixes in the meantime on this topic.

- Sedat -
