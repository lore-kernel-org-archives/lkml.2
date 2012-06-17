Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751942Ab2FQGYt (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Jun 2012 02:24:49 -0400
Received: from mailout-de.gmx.net ([213.165.64.23]:58190 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751197Ab2FQGYt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Jun 2012 02:24:49 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1/P8U50GqXP8TQXUPuSJGp2QVk9p2O9P6Ypy0ZiyO
	zlgBRJh5XIYc6x
Message-ID: <1339914285.7349.75.camel@marge.simpson.net>
Subject: Re: [PATCH][ANNOUNCE]RIFS-ES Scheduling V1 release.
From: Mike Galbraith <efault@gmx.de>
To: Chen <hi3766691@gmail.com>
Cc: linux-kernel@vger.kernel.org
Date: Sun, 17 Jun 2012 08:24:45 +0200
In-Reply-To: <CANQmPXip+fKaSYsKaY5TF3Rax=XFFgyh=+BY61snVsgpReL7RA@mail.gmail.com>
References: <CANQmPXip+fKaSYsKaY5TF3Rax=XFFgyh=+BY61snVsgpReL7RA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-06-17 at 01:18 +0800, Chen wrote:

> CFS is good with its beautiful design. But in my opinion i think the
> sleeper feature will destroy the beautiful design.

Destroys may be a bit strong, but it does have it's problems, one being:
as resource contention increases, so does total sleep.

It would be great to come up with a model that works as well at letting
light tasks compete without the downsides, but until that happens, this
model is better than none at all.  With no wakeup preemption model, the
scheduler is not fair to light tasks, a big hairy wart IMHO, which mars
the beauty more than sleep model "beauty marks" (ok, so they're warts).

"Beauty is in the eye of the beholder" and "Perfect is the enemy of
good" are both applicable.. as is "Math is hard, let's go shopping" :)

-Mike

