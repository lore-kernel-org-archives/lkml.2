Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756854Ab1ESNHK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 May 2011 09:07:10 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:58420 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756558Ab1ESNHI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 May 2011 09:07:08 -0400
Date: Thu, 19 May 2011 15:07:24 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, linux-sh@vger.kernel.org
Subject: Re: [PATCH] PM: Remove CONFIG_PM_VERBOSE
Message-ID: <20110519130723.GB4996@elf.ucw.cz>
References: <201105140042.04064.rjw@sisk.pl>
 <201105162032.33480.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201105162032.33480.rjw@sisk.pl>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-05-16 20:32:33, Rafael J. Wysocki wrote:
> On Saturday, May 14, 2011, Rafael J. Wysocki wrote:
> > From: Rafael J. Wysocki <rjw@sisk.pl>
> > 
> > Now that we have CONFIG_DYNAMIC_DEBUG there is no need for yet
> > another flag causing dev_dbg() and pr_debug() statements in the
> > core PM code to produce output.  Moreover, CONFIG_PM_VERBOSE
> > causes so much output to be generated that it's not really useful
> > and almost no one sets it.
> > 
> > References: https://bugzilla.kernel.org/show_bug.cgi?id=23182
> > Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

ACK

> There are no comments, so my understanding is that no one has any objections to
> this patch.  If that really is the case, I'm going to put it into
> suspend-2.6/linux-next for 2.6.40.

And sorry for slow responses.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
