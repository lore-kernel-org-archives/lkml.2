Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756938Ab0JAOAx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 10:00:53 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:36477 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756693Ab0JAOAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 10:00:52 -0400
Date: Thu, 30 Sep 2010 16:29:06 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM: Allow wakeup events to abort
 freezing of tasks
Message-ID: <20100930142903.GA1442@ucw.cz>
References: <201009300016.50128.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009300016.50128.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 2010-09-30 00:16:50, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM: Allow wakeup events to abort freezing of tasks
> 
> If there is a wakeup event during the freezing of tasks, suspend or
> hibernation will fail anyway.  Since try_to_freeze_tasks() can take
> up to 20 seconds to complete or fail, aborting it as soon as a wakeup
> event is detected improves the worst case wakeup latency.
> 
> Based on a patch from Arve Hj??nnev??g.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
