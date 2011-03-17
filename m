Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755038Ab1CQTvQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Mar 2011 15:51:16 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63459 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab1CQTvP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Mar 2011 15:51:15 -0400
Date: Thu, 17 Mar 2011 13:51:12 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [patch 0/5] gpio: langwell: Cleanup the interrupt mess
Message-ID: <20110317195112.GE12824@angua.secretlab.ca>
References: <20110317192247.722047296@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317192247.722047296@linutronix.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 07:32:43PM -0000, Thomas Gleixner wrote:
> The langwell interrupt handler is interesting and breaks when an
> architecture enables GENERIC_HARDIRQS_NO_DEPRECATED.
> 
> Also this driver along with the other intel ones should depend on x86.
> 
> The series cleans that up. The last patch 5/5 is RFC and needs a
> close look and testing by folks at Intel.

Applied first 4, thanks.  Will apply last one when I get acks from the
Intel folks.

g.

