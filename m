Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755319Ab1KXJvR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Nov 2011 04:51:17 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:34784 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753295Ab1KXJvQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Nov 2011 04:51:16 -0500
Date: Thu, 24 Nov 2011 10:51:13 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] PM / Hibernation: Refactor and simplify
 hibernation_snapshot() code
Message-ID: <20111124095113.GA2036@elf.ucw.cz>
References: <20111122212500.11648.2252.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111122212500.11648.2252.stgit@srivatsabhat.in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2011-11-23 02:55:40, Srivatsa S. Bhat wrote:
> The goto statements in hibernation_snapshot() are a bit complex.
> Refactor the code to remove some of them, thereby simplifying the
> implementation.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

ACK.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
