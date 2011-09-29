Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756635Ab1I2UCn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Sep 2011 16:02:43 -0400
Received: from mx3-phx2.redhat.com ([209.132.183.24]:46906 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751773Ab1I2UCm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Sep 2011 16:02:42 -0400
Date: Thu, 29 Sep 2011 16:00:05 -0400 (EDT)
From: Doug Ledford <dledford@redhat.com>
To: Andrew Morton <akpm00@gmail.com>
Cc: stable-review@kernel.org, torvalds@linux-foundation.org,
        alan@lxorguk.ukuu.org.uk, Jiri Slaby <jslaby@suse.cz>,
        Manfred Spraul <manfred@colorfullife.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, Greg KH <gregkh@suse.de>
Subject: Re: [159/244] ipc/mqueue.c: fix mq_open() return value
Message-ID: <27472e91-046e-4160-85fe-b775d5ac02cd@zmail05.collab.prod.int.phx2.redhat.com>
In-Reply-To: <20110929123715.004f4651.akpm00@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.11.231.143]
X-Mailer: Zimbra 7.1.2_GA_3268 (ZimbraWebClient - FF3.0 (Linux)/7.1.2_GA_3268)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

----- Original Message -----
> On Thu, 29 Sep 2011 12:08:55 -0700
> 
> Doug, the thing to do here is to rework your recent mqueue patchset.
> Prepare a minimal, critical-stuff series of bugfix patches against
> current Linus mainline which is also applicable to -stable.  We can
> merge that into 3.1 or, more likely, into 3.2-rc1/3.1.x.

The original patchset was against a clean Linus mainline, so that's already done.

> Then, later, we can merge up the less critical parts of that
> patchset.
> 
> otoh, the only not-applicable-to-stable part of that patchset appears
> to be "[1/5] ipc/mqueue: cleanup definition names and locations" and
> it's fairly small.  So we could perhaps just merge all five into
> 3.2-rc1, with a -stable backport.

That would be my suggestion.

> Doing that backport would require that we first backport the buggy
> patches (ie: this one), which is a bit weird.  Perhaps it would be
> better for you to prepare a reworked patch series for 3.0.x after
> that five-patch series hits mainline.

That or drop the buggy patch from -stable then fix it all in one go.

-- 
Doug Ledford <dledford@redhat.com>
              GPG KeyID: CFBFF194
	      http://people.redhat.com/dledford

