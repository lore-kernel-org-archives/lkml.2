Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751206Ab1DOFkt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Apr 2011 01:40:49 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:50088 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750720Ab1DOFks (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Apr 2011 01:40:48 -0400
Date: Fri, 15 Apr 2011 07:40:31 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Ortwin Gl?ck <odi@odi.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: High latency in wine after suspend
Message-ID: <20110415054026.GA1484@ucw.cz>
References: <4D89E99F.30808@odi.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4D89E99F.30808@odi.ch>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> After a suspend/resume cycle I see intermittent high latency in
> poll_schedule_timeout (latencytop). This leads to the mouse cursor
> freezing for several seconds sometimes when switching to/from a window
> of a wine process. The problem never occurs before suspend, but always
> occurs after. Any ideas what could cause such behaviour? Kernel is
> vanilla 2.6.38 x86_64 running on a recent HP laptop with Intel chipset.

Was this solved somehow? Can you try to  find "smaller" testcase --
anything less complex than wine? What about hibernation?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
