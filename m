Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756009Ab0FUAHK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jun 2010 20:07:10 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:42403 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754434Ab0FUAHG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jun 2010 20:07:06 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=googlemail.com; s=gamma;
        h=mime-version:reply-to:in-reply-to:references:date:message-id
         :subject:from:to:cc:content-type:content-transfer-encoding;
        b=xAQ3vN7kSLyzbWQMLWWpvwDJcY+FDJ+TATXe92vF2lXde/PWfuDPTrx1yb0hUFxb3r
         3ikVHjfi4H2dkl7UOeKMuPlyHuiHgEyYOFbCRVeS55t/3lX5NKXlqPomcvBq0kvGbkIs
         z0/f3lW2rLUQW69z9dK8t3UiiaHMXV7Cj8bZo=
MIME-Version: 1.0
Reply-To: sedat.dilek@gmail.com
In-Reply-To: <W8JfMs9cZw.A.PcG.hNpHMB@chimera>
References: <lc60d4toGTL.A.QzD._LpHMB@chimera>
	<W8JfMs9cZw.A.PcG.hNpHMB@chimera>
Date: Mon, 21 Jun 2010 02:07:04 +0200
Message-ID: <AANLkTilVdN0qLq7v0H7wbxuNwlcVJ_5jjrW6q0_Nqm4F@mail.gmail.com>
Subject: Re: [Bug #16169] Complain from preemptive debug
From: Sedat Dilek <sedat.dilek@googlemail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       Kernel Testers List <kernel-testers@vger.kernel.org>,
       Maciej Rutecki <maciej.rutecki@gmail.com>,
       Dmitry Monakhov <dmonakhov@openvz.org>,
       Andrew Morton <akpm@linux-foundation.org>, cpufreq@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Rafael,

Andrew answered in [1]:

"I just merged a different patch whcih should address this:
From: Sergey Senozhatsky <sergey.senozhatsky@gmail.com>"

This alternative patch is fixing the problem here, too.

Kind Regards,
- Sedat -

[1] https://patchwork.kernel.org/patch/106555/


On Mon, Jun 21, 2010 at 12:17 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> This message has been generated automatically as a part of a summary report
> of recent regressions.
>
> The following bug entry is on the current list of known regressions
> from 2.6.34.  Please verify if it still should be listed and let the tracking team
> know (either way).
>
>
> Bug-Entry       : http://bugzilla.kernel.org/show_bug.cgi?id=16169
> Subject         : Complain from preemptive debug
> Submitter       : Sedat Dilek <sedat.dilek@googlemail.com>
> Date            : 2010-05-31 10:10 (21 days old)
> Message-ID      : <AANLkTilTnAAZIizKinYsxFkNTkrmPqk6XJJuUjjhJ7EP@mail.gmail.com>
> References      : http://lkml.org/lkml/2010/5/31/77
> Handled-By      : Dmitry Monakhov <dmonakhov@openvz.org>
> Patch           : http://www.spinics.net/lists/cpufreq/msg01631.html
>
>
>
