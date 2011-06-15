Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753339Ab1FOMDi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jun 2011 08:03:38 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:58802 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751270Ab1FOMDg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jun 2011 08:03:36 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=LeZs5dcfWghO2I6Qco4GolYxNzCy4XuO5ZDgl/X/noUHQ/wioAkdN+8kus3RO3wUvX
         WxXTZowiIaak1a8+ZKjLjhkeH5FM28MfpOL9tdOm7T5JGFfQDTIzicpDA3esHBY4Xs0V
         AzdIbV53tIHRCcax7R5N8GuTYaSHOw0kBe5eA=
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
References: <alpine.DEB.2.00.1106151111200.18110@ayla.of.borg>
Date: Wed, 15 Jun 2011 15:03:35 +0300
Message-ID: <BANLkTi=cY5ecJS+Mqo12OsZEkBiHn82GHw@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.0-rc3
From: Tomas Winkler <tomasw@gmail.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Linux Kernel Development <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 15, 2011 at 12:11 PM, Geert Uytterhoeven
<geert@linux-m68k.org> wrote:
> Below is the list of build error/warning regressions/improvements in
> v3.0-rc3[1] compared to v2.6.39[2].
>
> Summarized:
>  - build errors: +21/-66
>  - build warnings: +202/-421
>
> JFYI, when comparing v3.0-rc3 to v3.0-rc2[3], the summaries are:
>  - build errors: +20/-45
>  - build warnings: +92/-101
>
> Note that there may be false regressions, as some logs are incomplete.
> Still, they're build errors/warnings.
>
> In addition, I put the verbose summary at
> http://www.kernel.org/pub/linux/kernel/people/geert/linux-log/v3.0-rc3.summary.gz
> so you can easily find out for which configs and architectures the
> errors/warnings you're interested in are happening.
>
> Happy fixing! ;-)
>

>  -
>  + drivers/staging/mei/interrupt.c: warning: 'buffer' may be used uninitialized in this function:  => 198

This is a real issue, but I'm not able to reproduce this warning in my
compilation environment, even with sparse and CF="-Wall"
Any hints

Thanks
