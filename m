Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754489Ab0IXAnX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 20:43:23 -0400
Received: from infernal.debian.net ([87.230.26.131]:49441 "EHLO
	infernal.debian.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751990Ab0IXAnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 20:43:22 -0400
Date: Fri, 24 Sep 2010 02:43:11 +0200
From: Andreas Bombe <aeb@debian.org>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-m68k@vger.kernel.org,
        hch@lst.de
Subject: Re: [RFT PATCH] amiga, atari floppy: Use one request queue per disk
Message-ID: <20100924004310.GA4134@amos.infernal>
References: <1285271646-2768-1-git-send-email-vgoyal@redhat.com>
 <20100923223530.GA5658@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100923223530.GA5658@redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 23, 2010 at 06:35:30PM -0400, Vivek Goyal wrote:
> On Thu, Sep 23, 2010 at 03:54:04PM -0400, Vivek Goyal wrote:
> > Would be great if somebody who has the hardware can lend a hand here to
> > see if these patches work.

Last time I looked at it (well over a year ago), amiflop was seriously
bitrotted from disuse. Just a warning, it may not work properly even
before applying these patches.


Andreas Bombe
