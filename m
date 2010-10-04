Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756718Ab0JDR6M (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 13:58:12 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47767 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755894Ab0JDR6K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 13:58:10 -0400
Date: Mon, 4 Oct 2010 19:58:03 +0200
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [linux-pm] [RFC][PATCH] PM / Hibernate: Make some boot
 messages look less scary
Message-ID: <20101004175803.GJ1518@ucw.cz>
References: <201009240056.41308.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201009240056.41308.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2010-09-24 00:56:41, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> Subject: PM / Hibernate: Make some boot messages look less scary
> 
> The hibernate resume code checks if there is an image to resume from
> on every boot and, if the kernel is built with CONFIG_PM_DEBUG set
> and the image is not present, it prints some scary messages
> suggesting there was a boot error of some sort.  Apparently, some
> users are confused by them, so make them look less scary and adjust
> the other hibernate resume debug messages to match them.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
