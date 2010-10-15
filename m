Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756721Ab0JOTYj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 15:24:39 -0400
Received: from mail-pz0-f66.google.com ([209.85.210.66]:59381 "EHLO
	mail-pz0-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756177Ab0JOTYh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 15:24:37 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=m8JCQ10/HObU+by1Xb4kIeYqrjXZlEk2KXuHI8yRjlYboG8fbO7MTnmblZqd8OMqxi
         Tdk3FK6Mq/Bvv8RaWrvw6mYisv9sJqdFdpE53DdeBamoIiKA22AuI85I2AfAjj+T5MPq
         FYfkSl+dqg3K1JBa34wirAh+nc7atg/pgeqBQ=
MIME-Version: 1.0
In-Reply-To: <4CB7D8DC.6010003@zytor.com>
References: <AANLkTi=29x3ng4uhUAMewe5Gr25ayDknJS9iGS4c51Yw@mail.gmail.com>
	<4CB7D8DC.6010003@zytor.com>
Date: Fri, 15 Oct 2010 12:11:10 -0700
Message-ID: <AANLkTimx81x191tWOR-NWD6EqD4V2yg54bmDiUUHKUpK@mail.gmail.com>
Subject: Re: kernel won't boot if kernel image passes 0xffffffff82000000
From: Rong Xu <rong.xu3@gmail.com>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the information. I just tried 2.6.34 and it indeed does not
have this problem. Do you remember which patch fixed this?  I tried
to search in the bugzilla but got no luck.

Regards,

-Rong

On Thu, Oct 14, 2010 at 9:30 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> On 10/14/2010 04:58 PM, Rong Xu wrote:
> >
> > I tried kernel 2.6.27 and it seems to have the same issue.
> >
> > Any comment?
>
> 2.6.26/27 are old kernels.  The current kernel is 2.6.35, with 2.6.36
> coming out very soon.
>
> As far as I know, this problem was found and fixed about two years ago,
> but if you could verify that so is indeed the case that would be useful.
>
> Thanks,
>
>        -hpa
>
> --
> H. Peter Anvin, Intel Open Source Technology Center
> I work for Intel.  I don't speak on their behalf.
>
