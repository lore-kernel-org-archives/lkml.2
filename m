Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752722Ab0IHRjQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 13:39:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:35074 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752080Ab0IHRjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 13:39:13 -0400
Date: Wed, 8 Sep 2010 19:39:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Kay Sievers <kay.sievers@vrfy.org>
Cc: greg@kroah.com, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>, axboe@kernel.dk
Subject: Re: [PATCH] SYSFS: Allow boot time switching between deprecated and
 modern sysfs layout v2
Message-ID: <20100908193910.2d27a33b@basil.nowhere.org>
In-Reply-To: <AANLkTimwX_RQfdqbotgdZax-=MLATi7WjsBjkZ+86aaw@mail.gmail.com>
References: <1283957657-17740-1-git-send-email-andi@firstfloor.org>
	<AANLkTimwX_RQfdqbotgdZax-=MLATi7WjsBjkZ+86aaw@mail.gmail.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Sep 2010 17:27:37 +0200
Kay Sievers <kay.sievers@vrfy.org> wrote:

> On Wed, Sep 8, 2010 at 16:54, Andi Kleen <andi@firstfloor.org> wrote:
> > From: Andi Kleen <ak@linux.intel.com>
> >
> > I have some systems which need legacy sysfs due to old udev
> > versions, and it's a big hazzle to compile separate kernels for
> > them.
> 
> It's not udev, it's other tools making wrong assumptions like that
> directories can not be a symlink to a directory, or that a device is
> always the same parent device. It's also not udev which fails on newer
> installations, it's the lack of information in the non-extensible
> deprecated layout which makes all sorts of tools fail. So please
> work-off the text from the old help text instead of blaming the wrong
> things here. :)

Ok. I can either send out a new patch or Greg can change the description
of v2 to dish out the blame in a Kay approved matter when he merges it.
What you guys prefer.

-Andi


-- 
ak@linux.intel.com -- Speaking for myself only.
