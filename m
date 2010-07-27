Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab0G0S2V (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 14:28:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45369 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331Ab0G0S2U (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 14:28:20 -0400
Date: Tue, 27 Jul 2010 14:17:57 -0400
From: Jarod Wilson <jarod@redhat.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Greg KH <greg@kroah.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/15] STAGING: add lirc device drivers
Message-ID: <20100727181757.GD9465@redhat.com>
References: <20100726232546.GA21225@redhat.com>
 <4C4F0244.2070803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4F0244.2070803@redhat.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 12:59:00PM -0300, Mauro Carvalho Chehab wrote:
> Em 26-07-2010 20:25, Jarod Wilson escreveu:
> > This patch series adds the remaining lirc_foo device drivers to the staging
> > tree.
> >  drivers/staging/lirc/TODO               |    8 +

^^^

> Hi Jarod,
> 
> Please add a TODO file at staging/lirc, describing what's needed for
> the drivers to move to the IR branch.

See above. :)

It could use some further fleshing out though, particularly, some "known
issues that must be fixed in this specific driver" type things.


> Greg,
> 
> It is probably simpler to merge those files via my tree, as they depend
> on some changes scheduled for 2.6.36.

The patches were created against yesterday's linux-next tree, so I'd
assumed they could go in via staging for 2.6.36, but...

> Would it be ok for you if I merge them from my tree?

...it certainly doesn't matter to me if they go in this way instead.

-- 
Jarod Wilson
jarod@redhat.com

