Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758355Ab1KVLmK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Nov 2011 06:42:10 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:36703 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755693Ab1KVLmJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Nov 2011 06:42:09 -0500
Date: Tue, 22 Nov 2011 12:42:07 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: rjw@sisk.pl, len.brown@intel.com, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH] kernel/power/main.c : Fix indentation and remove
 extraneous whitespaces
Message-ID: <20111122114206.GA32023@elf.ucw.cz>
References: <20111119091233.27293.34295.stgit@srivatsabhat.in.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111119091233.27293.34295.stgit@srivatsabhat.in.ibm.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat 2011-11-19 14:42:41, Srivatsa S. Bhat wrote:
> Lack of proper indentation of the goto statement decreases the readability
> of code significantly. In fact, this made me look twice at the code to check
> whether it really does what it should be doing. Fix this.
> 
> And in the same file, there are some extra whitespaces. Get rid of them too.
> 
> Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
