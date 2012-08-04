Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574Ab2HDPti (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 11:49:38 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:60941 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753452Ab2HDPth (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 11:49:37 -0400
MIME-Version: 1.0
In-Reply-To: <CAHFgRy_uo2wgFjockPmQgS18X76NxEBAkzJKc_ELTEmhmjuYWA@mail.gmail.com>
References: <CAHFgRy_uo2wgFjockPmQgS18X76NxEBAkzJKc_ELTEmhmjuYWA@mail.gmail.com>
Date: Sat, 4 Aug 2012 17:49:35 +0200
Message-ID: <CAFLxGvwapPJthzm6=EzRmrhWRJn5YzKcSomD7GKeTX74zQTdag@mail.gmail.com>
Subject: Re: Why is there no nouveau driver maintainer listed in MAINTAINERS?
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Miles Lane <miles.lane@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 4, 2012 at 5:36 PM, Miles Lane <miles.lane@gmail.com> wrote:
> I would like to report an issue in the nouveau driver, but don't know
> who to report it to.

We have a script for this.

rw@raccoon:/media/data1/linux-2.6 (master)>
./scripts/get_maintainer.pl -f ./drivers/gpu/drm/nouveau
Ben Skeggs <bskeggs@redhat.com> (commit_signer:399/442=90%)
Dave Airlie <airlied@redhat.com> (commit_signer:40/442=9%)
Martin Peres <martin.peres@labri.fr> (commit_signer:35/442=8%)
linux-kernel@vger.kernel.org (open list)

-- 
Thanks,
//richard
