Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092Ab2GCMd5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Jul 2012 08:33:57 -0400
Received: from mail-vc0-f174.google.com ([209.85.220.174]:46935 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751280Ab2GCMd4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Jul 2012 08:33:56 -0400
MIME-Version: 1.0
In-Reply-To: <x498vf2lzv4.fsf@segfault.boston.devel.redhat.com>
References: <CAJd=RBC=cZO8boOQMqJi=q9H2tZNOfsu_=VrkFt4_ExJCrLePQ@mail.gmail.com>
	<x498vf2lzv4.fsf@segfault.boston.devel.redhat.com>
Date: Tue, 3 Jul 2012 20:33:55 +0800
Message-ID: <CAJd=RBAgVCgnVO-VG111JAfW_uWYrgfEvuhoz3M7h2fZb8o7iA@mail.gmail.com>
Subject: Re: [RFC patch] block: add round robin dispatch in noop IO scheduler
From: Hillf Danton <dhillf@gmail.com>
To: Jeff Moyer <jmoyer@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 3, 2012 at 3:36 AM, Jeff Moyer <jmoyer@redhat.com> wrote:
>
> NACK.  Noop means noop.  You can have a look, and maybe contribute to
> the work that Shaohua Li is doing.  He proposed an IOPS-based scheduler
> here:
>   http://lwn.net/Articles/474164/
>
I did find a bug in iops v2:)

After adding fairness, I want to use noop to drive SSD in desktop box,
and if more than 100 MB/s, I am happy with the minor change.

Non RFC should have been posted if a SSD on hand.

Thanks,
Hillf
