Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754483Ab2EEBBj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 21:01:39 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:61492 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752129Ab2EEBBi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 21:01:38 -0400
MIME-Version: 1.0
In-Reply-To: <1336153306.23481.33.camel@sauron.fi.intel.com>
References: <1336152428-24242-1-git-send-email-dedekind1@gmail.com>
	<1336153306.23481.33.camel@sauron.fi.intel.com>
Date: Fri, 4 May 2012 17:55:23 -0700
Message-ID: <CAN8TOE_KZQqB6gqA1ccUfQ3v+n_ZN9Hm1Q63QDkhf9GGhj7eEQ@mail.gmail.com>
Subject: Re: [PATCH 0/3] do not use s_dirt in JFFS2
From: Brian Norris <computersforpeace@gmail.com>
To: dedekind1@gmail.com
Cc: MTD Maling List <linux-mtd@lists.infradead.org>,
        David Woodhouse <dwmw2@infradead.org>,
        Linux Kernel Maling List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 4, 2012 at 10:41 AM, Artem Bityutskiy <dedekind1@gmail.com> wrote:
> On Fri, 2012-05-04 at 20:27 +0300, Artem Bityutskiy wrote:
>> This patch-set makes JFFS2 file-system stop using the VFS '->write_supers()'
>> call-back because I plan to remove it once all users are gone.
>
> I'd really appreciate if someone on the MTD list tested these patches.

Am I crazy, or did you send the cover letter without the patches?

Brian
