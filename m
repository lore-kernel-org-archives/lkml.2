Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754842Ab0DFMY2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Apr 2010 08:24:28 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:55408 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752081Ab0DFMYW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Apr 2010 08:24:22 -0400
Date: Tue, 6 Apr 2010 14:24:21 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3] laptop-mode: Make flushes per-device
Message-ID: <20100406122421.GN23510@kernel.dk>
References: <20091214195806.GV8742@kernel.dk> <1260901295-1821-1-git-send-email-mjg@redhat.com> <20100403171022.GB11397@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100403171022.GB11397@srcf.ucam.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 03 2010, Matthew Garrett wrote:
> On Tue, Dec 15, 2009 at 01:21:35PM -0500, Matthew Garrett wrote:
> > One of the features of laptop-mode is that it forces a writeout of dirty
> > pages if something else triggers a physical read or write from a device.
> > The current implementation flushes pages on all devices, rather than only
> > the one that triggered the flush. This patch alters the behaviour so that
> > only the recently accessed block device is flushed, preventing other
> > disks being spun up for no terribly good reason.
> 
> Hi Jens,
> 
> Can you remember if there were any more issues with this, or can this 
> version be merged now?

I think it's fine to merge, I'll queue it up for 2.6.35.

-- 
Jens Axboe

