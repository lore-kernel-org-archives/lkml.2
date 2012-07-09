Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752739Ab2GIS2W (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 14:28:22 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:33629 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752315Ab2GIS2U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 14:28:20 -0400
MIME-Version: 1.0
In-Reply-To: <20120709180328.GA4105@redhat.com>
References: <20120709180328.GA4105@redhat.com>
From: Kay Sievers <kay@vrfy.org>
Date: Mon, 9 Jul 2012 20:27:57 +0200
Message-ID: <CAPXgP11oP4aKyg=HUNrb3z_ZbPjU+_u338sD6uhxKyJ43Z8sgQ@mail.gmail.com>
Subject: Re: 3.5-rc6 printk formatting problem during oom-kill.
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>,
        Kay Sievers <kay@vrfy.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg Kroah-Hartmann <greg@kroah.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 9, 2012 at 8:03 PM, Dave Jones <davej@redhat.com> wrote:
> I noticed that the format of the oom-killer output seems to have changed, and
> now it spews stuff like..
>
> [49461.758070] lowmem_reserve[]:
> [49461.758071]  0
> [49461.758071]  2643
> [49461.758071]  3878
> [49461.758072]  3878
> [49461.758072]
> [49461.758072] Node 0

> Does the oom-killer code need modifying, or the printk code ?
> I know there's been some regressions in this area recently, but this is still
> happening on the current tree (8c84bf4166a4698296342841a549bbee03860ac0)

This likely fixes it:
  http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=kmsg-merge-cont.patch;hb=HEAD

Let me check if it does, and if I can reproduce it.

Thanks,
Kay
