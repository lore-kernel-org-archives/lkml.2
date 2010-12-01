Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755157Ab0LANWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Dec 2010 08:22:09 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:43266 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752905Ab0LANWH convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Dec 2010 08:22:07 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type:content-transfer-encoding;
        b=FhPR1dFOXwrpEJ4bDQRIKMLTLADzHfCo7/aAt5TcIl44F/x/pnA01IVlOK4JFpKpXh
         ZI5KCrvxsPnExbnCh9J2dHLGwM6hc5lGgYTcL5tu/U5g/FZrrCidjCDpCWM4CwScBGsK
         OqKWHTOAHluKmwiDUsL9k5g3QdXCAmibeJnmY=
MIME-Version: 1.0
In-Reply-To: <20101129220350.GA10923@core2.telecom.by>
References: <AANLkTimewZ4QhxzL2vOYYV85pegy8Fu6Rb4XUAPqGUXS@mail.gmail.com>
 <20101129081619.GD5218@cr0.nay.redhat.com> <AANLkTinnJjqmXmbpAYmV9Tsc0VJV=WDM+GY6Gi1cJFCB@mail.gmail.com>
 <4CF36741.9000808@loongson.cn> <AANLkTiktPFtCdYpZai-L_WCOpBrZYN5yN_V7GZ5tKGXG@mail.gmail.com>
 <4CF3762B.9010102@loongson.cn> <13700.1291054229@localhost> <20101129220350.GA10923@core2.telecom.by>
From: Hui Zhu <teawater@gmail.com>
Date: Wed, 1 Dec 2010 21:21:45 +0800
Message-ID: <AANLkTi=Wuc18P8k8X63S8cDZ=3jzS-SievKGD7p=NUcM@mail.gmail.com>
Subject: Re: [hellogcc] Re: [PATCH] Built kernel without -O2 option
To: Alexey Dobriyan <adobriyan@gmail.com>
Cc: Valdis.Kletnieks@vt.edu, =?GB2312?B?x8ez5w==?= <qiaochong@loongson.cn>,
        hellogcc@freelists.org,
        =?ISO-8859-1?Q?Am=E9rico_Wang?= <xiyou.wangcong@gmail.com>,
        linux-kernel@vger.kernel.org, gdb@sourceware.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 30, 2010 at 06:03, Alexey Dobriyan <adobriyan@gmail.com> wrote:
> On Mon, Nov 29, 2010 at 01:10:29PM -0500, Valdis.Kletnieks@vt.edu wrote:
>> That may result in issues - the problem is that there are places in the kernel
>> where 'gcc -O0' will *compile* cleanly, but not actually *run* correctly.
>
> Since nobody (no-bo-dy) runs kernel with -O0, I'd suggest original
> poster to learn how to debug kernel with constrained information.
>
> I'll be most certainly faster. :^)
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>

Do you know Linux kernel cannot be built with "gcc -O0" now?
I think you should said "Since nobody (no-bo-dy) don't want built
kernel with -O0".

But how you know all the people's idea?  :)

Thanks,
Hui
