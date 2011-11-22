Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758473Ab1KVLmf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:42:35 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36710 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758455Ab1KVLmd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:42:33 -0500
Date: Tue, 22 Nov 2011 12:42:32 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, shuox.liu@intel.com
Subject: Re: [PATCH] PM / Suspend: Fix bug in suspend statistics update
Message-ID: <20111122114231.GB32023@elf.ucw.cz>
References: <20111119092019.27505.77215.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111119092019.27505.77215.stgit@srivatsabhat.in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2011-11-19 14:50:26, Srivatsa S. Bhat wrote:
> A pair of missing braces inside the state_store() function causes even
> invalid arguments to suspend to be wrongly treated as failed suspend
> attempts. Fix this.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

ACK.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
