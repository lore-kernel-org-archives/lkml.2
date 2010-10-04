Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753324Ab0JDHtM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 03:49:12 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59775 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752857Ab0JDHtL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 03:49:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:from:date:message-id:subject:to
         :cc:content-type;
        b=uSLsAWxiXza2okT3iQkzoDnARu1FKmAvyXBfrGFGuTLyqAkzrGMDjuJibv2dkYS/rM
         Fsw4ClXVKYrjHhwvU1BHJvC3ZgMSJlqCYjd0KRXOLzt9K47Vs9NUW/wJhWae64iCMTas
         NnLDqhV3vYxy8ieohcAHbu76g15S8m4NKTJ8M=
MIME-Version: 1.0
In-Reply-To: <1286177435.2140.5.camel@sven>
References: <1286177435.2140.5.camel@sven>
From: Eric Miao <eric.y.miao@gmail.com>
Date: Mon, 4 Oct 2010 15:48:48 +0800
Message-ID: <AANLkTik581EC953iBtZ3w46AX0PsK=2H=Pg0XAoObSc2@mail.gmail.com>
Subject: Re: 2.6.35.6 fails to suspend (pxa2xx-mci.0)
To: Sven Neumann <s.neumann@raumfeld.com>
Cc: linux-mmc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, Daniel Mack <daniel@caiaq.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 4, 2010 at 3:30 PM, Sven Neumann <s.neumann@raumfeld.com> wrote:
> Hi,
>
> we are running an embedded system here based on the PXA300 platform.
> Suspend/resume used to work well so far. However after upgrading the
> kernel from 2.6.34.7 to 2.6.35.6, we get the following error when trying
> to suspend the system:
>

I wonder if it's related to this issue:

https://bugs.launchpad.net/ubuntu/+source/linux-mvl-dove/+bug/530432

The issue above is not dove specific.
> # echo "mem" > "/sys/power/state"
> [ 5647.295953] PM: Syncing filesystems ... done.
> [ 5647.318792] Freezing user space processes ... (elapsed 0.01 seconds) done.
> [ 5647.337048] Freezing remaining freezable tasks ... (elapsed 0.01 seconds) done.
> [ 5647.356915] Suspending console(s) (use no_console_suspend to debug)
> [ 5647.366651] pm_op(): platform_pm_suspend+0x0/0x5c returns -38
> [ 5647.366671] PM: Device pxa2xx-mci.0 failed to suspend: error -38
> [ 5647.367082] PM: Some devices failed to suspend
>
>
> Regards,
> Sven
>
>
> --
> Sven Neumann
> Head of Software Development
>
> RAUMFELD GmbH | Reichenberger Str. 124 | 10999 Berlin | Germany
> Tel: +49.30.340.60.98.0 | Fax: +49.30.340.60.98.99 | s.neumann@raumfeld.com
>
>
> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
>
