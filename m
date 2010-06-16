Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759030Ab0FPOqU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jun 2010 10:46:20 -0400
Received: from cantor.suse.de ([195.135.220.2]:58996 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759012Ab0FPOqS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jun 2010 10:46:18 -0400
Date: Wed, 16 Jun 2010 16:46:12 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
X-X-Sender: jikos@twin.jikos.cz
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org, Jiri Kosina <jkosina@suse.cz>,
       Mika Kuoppala <mika.kuoppala@nokia.com>,
       Benjamin Tissoires <tissoire@cena.fr>, Rafi Rubin <rafi@seas.upenn.edu>
Subject: Re: [PATCH 0/3] input: evdev: Dynamic buffers (rev4)
In-Reply-To: <201006101211.51395.dmitry.torokhov@gmail.com>
Message-ID: <alpine.LRH.2.00.1006161645380.2497@twin.jikos.cz>
References: <1275735869-2185-1-git-send-email-rydberg@euromail.se> <201006101211.51395.dmitry.torokhov@gmail.com>
User-Agent: Alpine 2.00 (LRH 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Jun 2010, Dmitry Torokhov wrote:

> > This version implements buffer locking using event_lock as you
> > suggested, such that we can proceed with fixing the evdev buffer
> > problem independently from providing a suitable one-to-many buffer.
> > 
> > The first patch converts the per-client buffers to a common buffer,
> > and adds a fixme since the code is expected to be further
> > improved. The second and third patch includes your review comments.
> 
> Henrik,
> 
> Applied to .36 queue with minor adjustments, please take a peek in my
> 'for-linus' branch and see if you spot anything wrong. 

Hi Dmitry,

I guess you forgot to push it to kernel.org? Last change I see in your 
tree is 6 days old.

Thanks,

-- 
Jiri Kosina
SUSE Labs, Novell Inc.

