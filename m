Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760166Ab2EIQQm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 12:16:42 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:55341 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760135Ab2EIQQg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 12:16:36 -0400
MIME-Version: 1.0
In-Reply-To: <20120508121946.c20adb87.akpm@linux-foundation.org>
References: <1335884506-15370-1-git-send-email-bryan.wu@canonical.com>
 <CAK5ve-J9uTJKC01XFTzU34MY4z_8yVRwTUVXP99Czu=oL-mqxQ@mail.gmail.com> <20120508121946.c20adb87.akpm@linux-foundation.org>
From: Bryan Wu <bryan.wu@canonical.com>
Date: Thu, 10 May 2012 00:16:14 +0800
X-Google-Sender-Auth: rK3GolzYry5zjaSdjPLnmIQrckY
Message-ID: <CAK5ve-KSyvZSHw7csQ5M88q0008NSrs1kwuyUH3hFqxD0f7BQQ@mail.gmail.com>
Subject: Re: [PATCH v9 00/19] Introduce a led trigger for CPU activity and
 consolidate LED driver in ARM
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux@arm.linux.org.uk, rpurdie@rpsys.net,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@linaro.org, arnd.bergmann@linaro.org,
        nicolas.pitre@linaro.org, tim.gardner@canonical.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 9, 2012 at 3:19 AM, Andrew Morton <akpm@linux-foundation.org> wrote:
> On Wed, 9 May 2012 01:45:43 +0800
> Bryan Wu <bryan.wu@canonical.com> wrote:
>
>> Any comments and suggestions about my v9 patchset.
>
> The drivers/leds/ changes look OK to me.

Thanks a lot, Andrew.
Richard, what about merging this driver firstly in drivers/leds/?

Best Regards,
-- 
Bryan Wu <bryan.wu@canonical.com>
Kernel Developer    +86.186-168-78255 Mobile
Canonical Ltd.      www.canonical.com
Ubuntu - Linux for human beings | www.ubuntu.com
