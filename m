Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932124Ab1C1Rsw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 13:48:52 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:54900 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754758Ab1C1Rsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 13:48:51 -0400
MIME-Version: 1.0
In-Reply-To: <BANLkTinTbez8+AMF9KaAx+Y5NFW_RMP5ig@mail.gmail.com>
References: <Pine.LNX.4.64.1103242007300.2677@boston.corp.fedex.com>
 <20110324122409.GA1564@srcf.ucam.org> <AANLkTinKrG-N8O4_qf4SWuZ+W6VvFhyyLEw2ht0PFKSo@mail.gmail.com>
 <BANLkTimPvW0Y5yqaW7WngOghhZGafVZS6w@mail.gmail.com> <20110328125319.GA28847@srcf.ucam.org>
 <AANLkTik0Zt=ecj-p6GBSWwQMopE7GvmFV7b7jRv=y7yJ@mail.gmail.com>
 <20110328160241.GA20992@srcf.ucam.org> <BANLkTinTbez8+AMF9KaAx+Y5NFW_RMP5ig@mail.gmail.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Mar 2011 10:41:15 -0700
Message-ID: <AANLkTin1e0kn8uS6Hmz3y4kbCOGGKYpB+LU-vS2qsfKK@mail.gmail.com>
Subject: Re: Commit 9661e92c10a9775243c1ecb73373528ed8725a10: sysfs: cannot
 create duplicate filename '/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/device'
To: Alessandro Suardi <alessandro.suardi@gmail.com>
Cc: Matthew Garrett <mjg@redhat.com>, Jeff Chua <jeff.chua.linux@gmail.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Richard Purdie <rpurdie@rpsys.net>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        David Airlie <airlied@linux.ie>, Alex Deucher <alexdeucher@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>, Zhang Rui <rui.zhang@intel.com>,
        Len Brown <lenb@kernel.org>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        Sedat Dilek <sedat.dilek@googlemail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 28, 2011 at 10:25 AM, Alessandro Suardi
<alessandro.suardi@gmail.com> wrote:
>>
>> Sorry, yes - https://patchwork.kernel.org/patch/668351/
>
> Works on top of my -git18 + (unrelated) LVDS detection patch, thanks.
>
> Tested-by: Alessandro Suardi <alessandro.suardi@gmail.com>

Ok, which tree should this go through? I see from patchworks that it
was sent to linux-acpi and lkml, but the commit it fixes actually came
through Andrew.

Should I just take it directly?

                     Linus
