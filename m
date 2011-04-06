Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753613Ab1DFFcT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Apr 2011 01:32:19 -0400
Received: from ksp.mff.cuni.cz ([195.113.26.206]:57234 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751300Ab1DFFcR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Apr 2011 01:32:17 -0400
Date: Wed, 6 Apr 2011 07:32:16 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Amerigo Wang <amwang@redhat.com>
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        Len Brown <len.brown@intel.com>, Randy Dunlap <rdunlap@xenotime.net>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        linux-doc@vger.kernel.org, linux-pm@lists.linux-foundation.org
Subject: Re: [RESEND Patch] acpi: remove acpi_sleep=s4_nonvs
Message-ID: <20110406053216.GA24325@elf.ucw.cz>
References: <1302067724-14795-1-git-send-email-amwang@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1302067724-14795-1-git-send-email-amwang@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 2011-04-06 13:28:44, Amerigo Wang wrote:
> First post is here: https://lkml.org/lkml/2011/1/19/4
> 
> acpi_sleep=s4_nonvs is superseded by acpi_sleep=nonvs.
> 
> Acked-by: Rafael J. Wysocki <rjw@sisk.pl>
> Signed-off-by: WANG Cong <amwang@redhat.com>
> Cc: Len Brown <len.brown@intel.com>

ACK.

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
