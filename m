Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933547Ab0FROtG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jun 2010 10:49:06 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:53243 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757527Ab0FROtE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jun 2010 10:49:04 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Matt Turner <mattst88@gmail.com>
Subject: Re: [PATCH] DRM / radeon / KMS: Fix hibernation regression related to radeon PM (was: Re: [Regression, post-2.6.34] Hibernation broken on machines with radeon/KMS and r300)
Date: Fri, 18 Jun 2010 16:47:08 +0200
User-Agent: KMail/1.13.3 (Linux/2.6.35-rc3-rjw+; KDE/4.4.3; x86_64; ; )
Cc: Alex Deucher <alexdeucher@gmail.com>, Dave Airlie <airlied@redhat.com>,
       linux-kernel@vger.kernel.org,
       "dri-devel" <dri-devel@lists.freedesktop.org>,
       Andrew Morton <akpm@linux-foundation.org>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       linux-pm@lists.linux-foundation.org
References: <201006141653.03879.rjw@sisk.pl> <201006180102.27658.rjw@sisk.pl> <AANLkTinBTc7DEJd9PywNuD5HeIZhqHY4ePK3w78OwVJ4@mail.gmail.com>
In-Reply-To: <AANLkTinBTc7DEJd9PywNuD5HeIZhqHY4ePK3w78OwVJ4@mail.gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006181647.08916.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, June 18, 2010, Matt Turner wrote:
> On Thu, Jun 17, 2010 at 7:02 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
...
> > http://lists.freedesktop.org/mailman/listinfo/dri-devel
> 
> Probably want to shorten the commit title a bit.

In fact the title is just "DRM / radeon / KMS: Fix hibernation regression
related to radeon PM", the rest is to preserve the context.

Thanks,
Rafael
