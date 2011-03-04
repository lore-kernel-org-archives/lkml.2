Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759814Ab1CDPjB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Mar 2011 10:39:01 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:41056 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1759765Ab1CDPi7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Mar 2011 10:38:59 -0500
Date: Fri, 4 Mar 2011 16:38:50 +0100
From: Pavel Machek <pavel@ucw.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Len Brown <lenb@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        ACPI Devel Mailing List <linux-acpi@vger.kernel.org>,
        Linux PM mailing list <linux-pm@lists.linux-foundation.org>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 5/6] ACPI / PM: Merge do_suspend_lowlevel() into
 acpi_save_state_mem()
Message-ID: <20110304153850.GG1358@ucw.cz>
References: <201102072316.41270.rjw@sisk.pl>
 <201102072321.37565.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201102072321.37565.rjw@sisk.pl>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 2011-02-07 23:21:37, Rafael J. Wysocki wrote:
> From: Rafael J. Wysocki <rjw@sisk.pl>
> 
> The function do_suspend_lowlevel() is specific to x86 and defined in
> assembly code, so it should be called from the x86 low-level suspend
> code rather than from acpi_suspend_enter().
> 
> Merge do_suspend_lowlevel() into the x86's acpi_save_state_mem() and
> change the name of the latter to acpi_suspend_lowlevel(), so that the
> function's purpose is better reflected by its name.
> 
> Signed-off-by: Rafael J. Wysocki <rjw@sisk.pl>

Ack.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
