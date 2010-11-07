Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752792Ab0KGM4y (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Nov 2010 07:56:54 -0500
Received: from one.firstfloor.org ([213.235.205.2]:41373 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752106Ab0KGM4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Nov 2010 07:56:52 -0500
From: Andi Kleen <andi@firstfloor.org>
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC PATCH] SCSI host lock push-down
References: <20101105002409.GA21714@havoc.gtf.org>
Date: Sun, 07 Nov 2010 13:56:46 +0100
In-Reply-To: <20101105002409.GA21714@havoc.gtf.org> (Jeff Garzik's message of
	"Thu, 4 Nov 2010 20:24:10 -0400")
Message-ID: <8762w9thpt.fsf@basil.nowhere.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jeff Garzik <jeff@garzik.org> writes:

> There were some previous attempts to push the SCSI host lock down
> into each driver.  In both cases, authors working independently of
> each other managed to both (a) skip some drivers that need updates, and,
> (b) get the locking wrong in some cases and/or rewrite the locking.

I took a quick look and there are no obvious problems in this 
version (except of lack of cc to previous contributors)

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
