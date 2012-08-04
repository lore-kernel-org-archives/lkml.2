Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753607Ab2HDQdH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Aug 2012 12:33:07 -0400
Received: from mail-yx0-f174.google.com ([209.85.213.174]:61900 "EHLO
	mail-yx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753099Ab2HDQdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Aug 2012 12:33:05 -0400
Message-ID: <1344097981.4495.6.camel@ayu>
Subject: Re: Why is there no nouveau driver maintainer listed in MAINTAINERS?
From: Calvin Walton <calvin.walton@kepstin.ca>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: Miles Lane <miles.lane@gmail.com>, LKML <linux-kernel@vger.kernel.org>
Date: Sat, 04 Aug 2012 12:33:01 -0400
In-Reply-To: <CAFLxGvwapPJthzm6=EzRmrhWRJn5YzKcSomD7GKeTX74zQTdag@mail.gmail.com>
References: <CAHFgRy_uo2wgFjockPmQgS18X76NxEBAkzJKc_ELTEmhmjuYWA@mail.gmail.com>
	 <CAFLxGvwapPJthzm6=EzRmrhWRJn5YzKcSomD7GKeTX74zQTdag@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2012-08-04 at 17:49 +0200, richard -rw- weinberger wrote:
> On Sat, Aug 4, 2012 at 5:36 PM, Miles Lane <miles.lane@gmail.com> wrote:
> > I would like to report an issue in the nouveau driver, but don't know
> > who to report it to.
> 
> We have a script for this.
> 
> rw@raccoon:/media/data1/linux-2.6 (master)>
> ./scripts/get_maintainer.pl -f ./drivers/gpu/drm/nouveau
> Ben Skeggs <bskeggs@redhat.com> (commit_signer:399/442=90%)
> Dave Airlie <airlied@redhat.com> (commit_signer:40/442=9%)
> Martin Peres <martin.peres@labri.fr> (commit_signer:35/442=8%)
> linux-kernel@vger.kernel.org (open list)

In addition, the nouveau driver has its own mailing list, at
nouveau@lists.freedesktop.org - and they respond to issues on the
http://bugs.freedesktop.org/ bugzilla.

-- 
Calvin Walton <calvin.walton@kepstin.ca>

