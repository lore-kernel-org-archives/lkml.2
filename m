Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759730Ab1CDPiD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:38:03 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:40996 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759345Ab1CDPiB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:38:01 -0500
Date: Fri, 4 Mar 2011 16:37:37 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/6] ACPI / PM: Do not switch interrupts off/on in
 acpi_suspend_enter()
Message-ID: <20110304153737.GD1358@ucw.cz>
References: <201102072316.41270.rjw@sisk.pl>
 <201102072319.10327.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102072319.10327.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The function acpi_suspend_enter() is always called with interrupts
> off, so it doesn't need to switch them off and on.

Maybe add 'this function always runs with irqs disabled' comment?

Otherwise ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
