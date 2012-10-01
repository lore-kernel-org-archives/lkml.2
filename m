Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757411Ab2JAVAo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Oct 2012 17:00:44 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60604 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755491Ab2JAVAh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Oct 2012 17:00:37 -0400
Date: Mon, 1 Oct 2012 23:00:34 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-efi@vger.kernel.org
Subject: Re: [PATCH 02/11] PCI: Lock down BAR access in secure boot
 environments
Message-ID: <20121001210034.GA21712@elf.ucw.cz>
References: <1346774117-2277-1-git-send-email-mjg@redhat.com>
 <1346774117-2277-3-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1346774117-2277-3-git-send-email-mjg@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2012-09-04 11:55:08, Matthew Garrett wrote:
> Any hardware that can potentially generate DMA has to be locked down from
> userspace in order to avoid it being possible for an attacker to cause
> arbitrary kernel behaviour. Default to paranoid - in future we can
> potentially relax this for sufficiently IOMMU-isolated devices.

Would it be possible to

1) Use some better name than CAP_SECURE_FIRMWARE

2) Explain somewhere what the real requirements for "secure" boot are?

"Secure" kernel may not boot unsigned kernel... what does it mean
exactly?

Suppose I launch full-screen window with dosemu running original
windows installation on HDD, accessing raw disks, at nearly native
speed. That is not something kernel should prevent, but it still
allows me to do to do the stuff "secure" boot was designed to
prevent... right?

What is the exact threat "secure" boot should protect us against?

								Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
