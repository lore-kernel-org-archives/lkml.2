Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752736Ab1GCRPn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Jul 2011 13:15:43 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:55125 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752064Ab1GCRPl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Jul 2011 13:15:41 -0400
Date: Sun, 3 Jul 2011 19:15:39 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@lists.linux-foundation.org,
        Jiri Kosina <jkosina@suse.cz>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>, linux390@de.ibm.com,
        linux-s390@vger.kernel.org
Subject: Re: [PATCH 1/7] pm: improve error code of pm_notifier_call_chain()
Message-ID: <20110703171539.GF21127@elf.ucw.cz>
References: <1309702581-16863-1-git-send-email-akinobu.mita@gmail.com>
 <1309702581-16863-2-git-send-email-akinobu.mita@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1309702581-16863-2-git-send-email-akinobu.mita@gmail.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun 2011-07-03 23:16:15, Akinobu Mita wrote:
> This enables pm_notifier_call_chain() to get the actual error code
> in the callback rather than always assume -EINVAL by converting all
> PM notifier calls to return encapsulate error code with
> notifier_from_errno().
> 
> Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
> Cc: Pavel Machek <pavel@ucw.cz>

Nothing obviously wrong here.
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
