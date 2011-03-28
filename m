Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754631Ab1C1PWo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Mar 2011 11:22:44 -0400
Received: from smtp1.linux-foundation.org ([140.211.169.13]:51676 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753269Ab1C1PWn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Mar 2011 11:22:43 -0400
MIME-Version: 1.0
In-Reply-To: <20110328125319.GA28847@srcf.ucam.org>
References: <Pine.LNX.4.64.1103242007300.2677@boston.corp.fedex.com>
 <20110324122409.GA1564@srcf.ucam.org> <AANLkTinKrG-N8O4_qf4SWuZ+W6VvFhyyLEw2ht0PFKSo@mail.gmail.com>
 <BANLkTimPvW0Y5yqaW7WngOghhZGafVZS6w@mail.gmail.com> <20110328125319.GA28847@srcf.ucam.org>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 28 Mar 2011 08:22:05 -0700
Message-ID: <AANLkTik0Zt=ecj-p6GBSWwQMopE7GvmFV7b7jRv=y7yJ@mail.gmail.com>
Subject: Re: Commit 9661e92c10a9775243c1ecb73373528ed8725a10: sysfs: cannot
 create duplicate filename '/devices/pci0000:00/0000:00:02.0/backlight/acpi_video0/device'
To: Matthew Garrett <mjg@redhat.com>
Cc: Alessandro Suardi <alessandro.suardi@gmail.com>,
        Jeff Chua <jeff.chua.linux@gmail.com>,
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

On Mon, Mar 28, 2011 at 5:53 AM, Matthew Garrett <mjg@redhat.com> wrote:
>
> I just sent a patch to fix this.

Grr. Any more details, please? Who to? What's the fix? Actual patch
for reporters to validate?

                           Linus
