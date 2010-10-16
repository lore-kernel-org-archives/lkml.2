Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752205Ab0JPBJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 21:09:54 -0400
Received: from bombadil.infradead.org ([18.85.46.34]:52697 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751825Ab0JPBJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 21:09:53 -0400
Date: Fri, 15 Oct 2010 21:09:52 -0400
From: Kyle McMartin <kyle@mcmartin.ca>
To: torvalds@linux-foundation.org
Cc: linux-kernel@vger.kernel.org, takata@linux-m32r.org,
        linux-m32r@ml.linux-m32r.org, viro@zeniv.linux.org.uk
Subject: [PATCH 0/4] m32r: build fixes
Message-ID: <20101016010952.GQ8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Not sure if I should send this directly to you or not, but it seems like
m32r has not received much love recently. The following patches fix the
defconfig build of m32r for me (which I needed to do to test the
__do_IRQ removal.)

regards, Kyle
