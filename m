Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758281Ab0JFCGD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 22:06:03 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:46157 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab0JFCGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 22:06:01 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=R0j5njyuOXZ7PW36/bOwzwKQhn1iOnDwbZpRNcZrb6Yq2Vj08aYnSwmAwr7jVxA4kQ
         wAiyW18dkxPLA/EOP5KC8g3vfhEXKlkh4MvRxdSwfHNbbN1aAlJpDZxiLUnV972n0tZx
         ra5juOOlxJ81dY/kEKG1/UZInvuEqfDaWnEsQ=
MIME-Version: 1.0
In-Reply-To: <20101006015204.GA22411@kroah.com>
References: <AANLkTi=GrHjrZaKdX8DiDf2nT-SByifSxn2sW_0NQWd_@mail.gmail.com>
	<20101006015204.GA22411@kroah.com>
Date: Tue, 5 Oct 2010 22:06:01 -0400
Message-ID: <AANLkTi=7phj3BhSyBaoSy9KQ3=RuJp64hj_xDyU9q+HX@mail.gmail.com>
Subject: Re: [PATCH 00/28] Staging: comedi: Fixed numerous file so that it had
 little or no complaints from checkpatch.pl
From: T Dent <tdent48227@gmail.com>
To: Greg KH <greg@kroah.com>
Cc: abbotti@mev.co.uk, fmhess@users.sourceforge.net,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/5/10, Greg KH <greg@kroah.com> wrote:
> On Tue, Oct 05, 2010 at 09:15:16PM -0400, T Dent wrote:
>> I fixed a lot of coding style errors, that checkpatch.pl had found. I
>> didn't do some files in the drivers/ subdirectory because the warnings
>> that were being produce was spacing errors. So spacing wasn't that
>> serious ,so I skim and look for if it was anymore wranings or errors.
>> There was none so I skip the rest.
>>
>> This is my last full scale checkpatch.pl patch series, as I'm going to
>> try to contribute more interesting things to the Linux kernel. :)
>
> As mentioned in the response to 01/28, these are all just fine as-is and
> don't need to be changed, sorry.

Okay. Doesn't matter that much it was the last patche series I was
going to do like these.

> Go bug the checkpatch author to remove
> this from the tool.

I intend to.
>
> sorry,
>
> greg k-h
>
Thanks,

Tracey D
