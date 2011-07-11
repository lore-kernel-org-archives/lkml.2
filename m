Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757950Ab1GKVhZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jul 2011 17:37:25 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:57661 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751489Ab1GKVhY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jul 2011 17:37:24 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Kevin Hilman <khilman@ti.com>
Subject: Re: Please submit platform trees for inclusion in arm-soc.git v3.1
Date: Mon, 11 Jul 2011 23:37:08 +0200
User-Agent: KMail/1.12.2 (Linux/2.6.31-22-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, Thomas Gleixner <tglx@linutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>, linux-kernel@vger.kernel.org,
        Russell King <rmk@arm.linux.org.uk>
References: <201107012018.14619.arnd@arndb.de> <87wrfsahez.fsf@ti.com>
In-Reply-To: <87wrfsahez.fsf@ti.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201107112337.08892.arnd@arndb.de>
X-Provags-ID: V02:K0:Cc2OoOyaToOlh9Rn6kyNgCQsAvksQ74OWcwuaf3Ip66
 4kbgDrJqA0RiSZbjJnGtj4wU04Zy8MXBeEoa8biECNDnQ/WOgU
 xAEVCkj8qsL8xeS7r4dV6B80dGeG12WAv0YUEG12HV8ZC6jdto
 Yeo7seFC52lh/8znwHKAQ1+XD0s8XhuO9qME6rGMJ9UqYDB/RA
 Qb9QTafZlba1FQtxJKQ/A==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 08 July 2011, Kevin Hilman wrote:
> > Time is running out for the current cycle, so any changes that you
> > want to see merged in linux-3.1 through the arm-soc tree should be
> > submitted in form of pull-requests very soon.
> 
> [...]
> 
> It looks like your "remove rmk/for-next" commit may not have been
> totally complete.
> 
> Trying to merge your master branch and Russell's current for-next branch
> still results in conflicts in files that should only be touched in
> Russell's branch (specifically, these seem related to changes in
> Russell's 'suspend' branch that is included in his 'for-next' branch.)

Yes, that's my fault for not fixing this up correctly after initially
doing the incorrect pull.

I guess I'll throw away the current master branch and generate a new
one. After discussing this with Russell, I think it's best to treat
the master branch as temporary anyway unless Nicolas or Thomas come up
with a good reason against doing this.

	Arnd
