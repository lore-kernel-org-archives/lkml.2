Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751676Ab0G0QKF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 12:10:05 -0400
Received: from kroah.org ([198.145.64.141]:56905 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab0G0QKD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 12:10:03 -0400
Date: Tue, 27 Jul 2010 09:09:56 -0700
From: Greg KH <greg@kroah.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Jarod Wilson <jarod@redhat.com>, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [PATCH 0/15] STAGING: add lirc device drivers
Message-ID: <20100727160955.GA7528@kroah.com>
References: <20100726232546.GA21225@redhat.com>
 <4C4F0244.2070803@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C4F0244.2070803@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 27, 2010 at 12:59:00PM -0300, Mauro Carvalho Chehab wrote:
> Em 26-07-2010 20:25, Jarod Wilson escreveu:

Hm, Jarod, you forgot to cc: the staging maintainer, so I missed these
:)

> Please add a TODO file at staging/lirc, describing what's needed for
> the drivers to move to the IR branch.
> 
> Greg,
> 
> It is probably simpler to merge those files via my tree, as they depend
> on some changes scheduled for 2.6.36.
> 
> Would it be ok for you if I merge them from my tree?

No objection from me for them to go through your tree.

Do you want me to handle the cleanup and other fixes after they go into
the tree, or do you want to also handle them as well (either is fine
with me.)

thanks,

greg k-h
