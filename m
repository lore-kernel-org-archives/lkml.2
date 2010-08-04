Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932409Ab0HDKMU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Aug 2010 06:12:20 -0400
Received: from casper.infradead.org ([85.118.1.10]:55440 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932117Ab0HDKMS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Aug 2010 06:12:18 -0400
Subject: RE: [PATCH 1/2] mtdpart: memory accessor interface for MTD layer
From: David Woodhouse <dwmw2@infradead.org>
To: David Brownell <david-b@pacbell.net>
Cc: "'Kevin Hilman'" <khilman@deeprootsystems.com>,
        Sudhakar Rajashekhara <sudhakar.raj@ti.com>,
        "'Bernd Schmidt'" <bernd.schmidt@analog.com>,
        "'Nicolas Pitre'" <nico@fluxnic.net>, linux-kernel@vger.kernel.org,
        "'David Howells'" <dhowells@redhat.com>,
        "'David Brownell'" <dbrownell@users.sourceforge.net>,
        linux-mtd@lists.infradead.org,
        "'Andrew Morton'" <akpm@linux-foundation.org>
In-Reply-To: <54038.80733.qm@web180305.mail.gq1.yahoo.com>
References: <54038.80733.qm@web180305.mail.gq1.yahoo.com>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 04 Aug 2010 11:12:05 +0100
Message-ID: <1280916725.19499.12.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.31.6 
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <dwmw2@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-07-07 at 04:08 -0700, David Brownell wrote:
> 
> I think the short answer is that the callout is
> what provides the board drivers enough information
> to make the correct calls. 

I don't see how.

The only information it passes to the callout is the information it was
already *given* in the partition structure.

I'm more inclined to believe Sudhakar's claim that you'll get an
'initialization sequence problem', although I'm not sure I believe it
can't be solved in a better way than this.

I'm also unhappy that it only works on partitioned devices -- that seems
wrong.

-- 
David Woodhouse                            Open Source Technology Centre
David.Woodhouse@intel.com                              Intel Corporation


