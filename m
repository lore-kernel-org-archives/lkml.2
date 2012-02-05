Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754771Ab2BELid (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 06:38:33 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:42454 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753475Ab2BELic convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 06:38:32 -0500
MIME-Version: 1.0
In-Reply-To: <201202051107.26634.toralf.foerster@gmx.de>
References: <201202041109.53003.toralf.foerster@gmx.de>
	<201202041536.52189.toralf.foerster@gmx.de>
	<CAJd=RBC-aceg6JUzGEfD3hcwv+0yd2M_N9kpS0v-JDMMKFaj_Q@mail.gmail.com>
	<201202051107.26634.toralf.foerster@gmx.de>
Date: Sun, 5 Feb 2012 19:38:31 +0800
Message-ID: <CAJd=RBCvvVgWqfSkoEaWVG=2mwKhyXarDOthHt9uwOb2fuDE9g@mail.gmail.com>
Subject: Re: swap storm since kernel 3.2.x
From: Hillf Danton <dhillf@gmail.com>
To: =?UTF-8?Q?Toralf_F=C3=B6rster?= <toralf.foerster@gmx.de>
Cc: Johannes Stezenbach <js@sig21.net>, linux-kernel@vger.kernel.org,
        Rik van Riel <riel@redhat.com>, linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/2/5 Toralf Förster <toralf.foerster@gmx.de>:
>
> Hillf Danton wrote at 05:45:40
>> Would you please try the patchset of Rik?
>>
>>          https://lkml.org/lkml/2012/1/26/374
>
> It doesn't applied successfully agains 3.2.3 (+patch +f 3.2.5)
> :-(
>
That patchset already in -next tree, mind to try it with
CONFIG_SLUB_DEBUG first disabled, and try again with it enabled?

Hillf
