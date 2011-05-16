Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753717Ab1EPRbE (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 13:31:04 -0400
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57467 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1EPRbC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 13:31:02 -0400
Date: Mon, 16 May 2011 13:25:14 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: James Hogan <james@albanarts.com>
Cc: linux-wireless@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: BUG: scheduling while atomic 2.6.39-rc7 (iwl3945_irq_tasklet)
Message-ID: <20110516172513.GA2546@tuxdriver.com>
References: <20110513203448.GA3523@gandalf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513203448.GA3523@gandalf>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 09:34:49PM +0100, James Hogan wrote:
> Hi,
> 
> On 2.6.39-rc7 I've seen a panic due to "BUG: scheduling while atomic"
> with the backtrace below (not much detail as it was written in a text
> message while it was displayed on the screen!). All worked fine in
> 2.6.38.
> 
> This was soon after resuming from suspend (enough time to unlock the
> screen, but not much else). I think it was the same bug I saw in rc2 but
> didn't have time to track down. I can probably get it to happen again if
> more detail is needed. It doesn't happen every suspend (I think it had
> survived a couple of suspend/resume cycles at this point).
> 
> I could bisect if necessary, but hopefully the backtrace will be enough
> to see what's going on?

A bisect might be very helpful -- time is short for 2.6.39 already.

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
