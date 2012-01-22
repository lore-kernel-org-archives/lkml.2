Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751398Ab2AVJND (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Jan 2012 04:13:03 -0500
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:58736 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751091Ab2AVJNA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Jan 2012 04:13:00 -0500
Date: Sun, 22 Jan 2012 09:12:48 +0000
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: linux-pcmcia@lists.infradead.org,
        Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH,FIXED] PCMCIA card inserted, five s2ram cycles, you're
	dead
Message-ID: <20120122091248.GS1068@n2100.arm.linux.org.uk>
References: <20120122085157.GR1068@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120122085157.GR1068@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unfortunately, the description will need a couple of edits for it to
apply properly (I just applied it to a local private branch.)

On Sun, Jan 22, 2012 at 08:51:57AM +0000, Russell King - ARM Linux wrote:
> @@ -546,8 +524,8 @@ static int socket_late_resume(struct pcmcia_socket *skt)

This needs a space before it, otherwise git will try to take this as a
patch to be applied.

> Cc: <stable@vger.kernel.org>
> Tested-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> -- 

And I keep messing this marker up in hand-crafted messages.
