Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752077Ab1DZS1A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 14:27:00 -0400
Received: from mail-wy0-f174.google.com ([74.125.82.174]:40317 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954Ab1DZS07 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 14:26:59 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=Ioc+AKllFWmAFdkKro3a5QLKZTePIxBZcF573T/A0cSUpyHK9JcH5sug47HuZkaQ9R
         r0REt0QShfXFEj7SDNmn1bL4HMFPP4OHghsUEMIqF/seW3NMu12FtPJaNMPyqqjyYo4a
         p0n2D0lHbkIDQQZ+5ujkHKvszzCeE51iufHjA=
MIME-Version: 1.0
In-Reply-To: <20110425182906.2673.A69D9226@jp.fujitsu.com>
References: <20110425182906.2673.A69D9226@jp.fujitsu.com>
Date: Tue, 26 Apr 2011 15:26:58 -0300
Message-ID: <BANLkTikiyjWT4GmSopf=kW=_pGamQnTuGg@mail.gmail.com>
Subject: Re: [PATCH 0/4] blackfin: convet cpumask apis
From: Thiago Farina <tfransosi@gmail.com>
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Cc: Michael Hennerich <michael.hennerich@analog.com>,
        device-driver-devel@blackfin.uclinux.org,
        LKML <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 25, 2011 at 6:27 AM, KOSAKI Motohiro
<kosaki.motohiro@jp.fujitsu.com> wrote:
>
> Rusty Russle introduced a lot of cpumask related APIs. and He gone even

s/Russle/Russell

s/and He/And he/

> though the work is unfinished. This patch series is sequel of his work.
>
> No functional change. only api change.
>
> note: I've confirmed only cross-compile build. so, I hope blackfin
> developers see the code.
>
>
> KOSAKI Motohiro (4):
>  blackfin: remove unused function
>  blackfin: don't touch cpu_possible_map and cpu_present_map directly
>  blackfin: don't touch task->cpus_allowed directly
>  blackfin: convert old cpumask API to new one
>
>  arch/blackfin/kernel/nmi.c                  |    8 ++--
>  arch/blackfin/kernel/process.c              |    6 +--
>  arch/blackfin/kernel/setup.c                |    4 +-
>  arch/blackfin/mach-bf561/include/mach/smp.h |    2 -
>  arch/blackfin/mach-bf561/smp.c              |   27 ++++-------
>  arch/blackfin/mach-common/dpmc.c            |    7 ++-
>  arch/blackfin/mach-common/smp.c             |   27 ++++++-----
>
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/
>
