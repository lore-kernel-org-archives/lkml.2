Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754462Ab0IXUjX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Sep 2010 16:39:23 -0400
Received: from mail-qy0-f181.google.com ([209.85.216.181]:48880 "EHLO
	mail-qy0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752639Ab0IXUjW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Sep 2010 16:39:22 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=HX22Zbzw1vZZsJYS6u0ejB3wow3hiZGBqM9YGcgUol3F/2YRKjppY5tAxVzmlMymU0
         urQds56PHcm6kSpjsUAcipAwJHgQeY3LqHz2bEtgkslcpU5a0lP/nAM6cf5gbkUp2yYW
         C0qIMzR/ozUPFo/DgkTSdtgqU1J/mfT+jK7to=
MIME-Version: 1.0
In-Reply-To: <AANLkTikvGGz+33ni=Kov1qM1DpSj2WVuk89u=TwE9iL_@mail.gmail.com>
References: <AANLkTikqf4rn6BP2gyQAuQrvt7EdFY8yfa+o8nfR9xWE@mail.gmail.com>
	<AANLkTikvGGz+33ni=Kov1qM1DpSj2WVuk89u=TwE9iL_@mail.gmail.com>
Date: Fri, 24 Sep 2010 16:39:20 -0400
Message-ID: <AANLkTin1YfwwVcDNUBsi34iYC6HA5Y6+uOFZN=+Q2hqs@mail.gmail.com>
Subject: Re: [PATCH 00/21] Staging: cleaned up makefiles cflag lines
From: T Dent <tdent48227@gmail.com>
To: matt mooney <mfmooney@gmail.com>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 9/24/10, matt mooney <mfmooney@gmail.com> wrote:
> On Fri, Sep 24, 2010 at 11:25 AM, T Dent <tdent48227@gmail.com> wrote:
>> I changed every makefile in the staging directory to use the proper
>> ccflags-y option instead of EXTRA_CFLAGS. It builds also :) .
>
> Um, you didn't do a lot of these right. Maybe you should look into why
> the change was made in the first place. For semantic reasons, I was
> also changing the first assignment to ":=" from "+=".

I can resend them with the a small modification to the patch files if you want.

>
> Thanks,
> mfm
>
> --
> GPG-Key: 9AFE00EA
>
 Thanks,
Tracey Dent
