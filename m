Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752966Ab1FHR2H (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jun 2011 13:28:07 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:63841 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750986Ab1FHR2C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jun 2011 13:28:02 -0400
Date: Wed, 8 Jun 2011 11:27:59 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: David Jander <david@protonic.nl>
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 1/6] GPIO: pca953x.c: Fix IRQ support.
Message-ID: <20110608172759.GJ8499@ponder.secretlab.ca>
References: <1307537314-4345-1-git-send-email-david@protonic.nl>
 <1307537314-4345-2-git-send-email-david@protonic.nl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307537314-4345-2-git-send-email-david@protonic.nl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 08, 2011 at 02:48:29PM +0200, David Jander wrote:
> It seems that in the normal case, IRQ_NOREQUEST needs to be explicitly
> cleared, otherwise claiming the interrupt fails.
> In the case of sparse interrupts, the descriptor needs to be allocated
> first.
> 
> Signed-off-by: David Jander <david@protonic.nl>

Merged, thanks

g.

