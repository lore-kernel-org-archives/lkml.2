Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932302Ab1KGMmy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Nov 2011 07:42:54 -0500
Received: from mail-bw0-f46.google.com ([209.85.214.46]:46176 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753543Ab1KGMmx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Nov 2011 07:42:53 -0500
MIME-Version: 1.0
In-Reply-To: <4EB7A6CC.5030502@gmx.net>
References: <20111106183851.GA4339@shiny> <CAK-xaQau04whLQm0Fz-fkCZ1AumLs84UiqGi0Rc=GZUzRvV7Gg@mail.gmail.com>
 <4EB7A6CC.5030502@gmx.net>
From: Andrea Gelmini <andrea.gelmini@gmail.com>
Date: Mon, 7 Nov 2011 13:42:31 +0100
Message-ID: <CAK-xaQbvpZQzPVxunSEVDzTXXzQ2HaQWHVR3BwR1iq95URWEdw@mail.gmail.com>
Subject: Re: [GIT PULL] Btrfs pull request
To: Arne Jansen <sensille@gmx.net>
Cc: Chris Mason <chris.mason@oracle.com>,
        linux-btrfs <linux-btrfs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2011/11/7 Arne Jansen <sensille@gmx.net>:
> On what platform are you running this? Can you please try this after
> a fresh boot? Maybe there's an allocation that can't be served with
> a badly fragmented memory.

Hi Arne,
   and thanks a lot for your reply.
   So:
   a) it's a fresh Ubuntu 11.04, with latest Linus git tree
(31555213f03bca37d2c02e10946296052f4ecfcd), and latest btrfs progs
(13eced9a0c2b6bd6bc38e6f0f46a1977b1167e67), plus Chris btrfs branch
for-linus;
   b) same problem after a fresh boot.

Thanks,
Andrea
