Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753784Ab2BQT1P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Feb 2012 14:27:15 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:60477 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752542Ab2BQT1L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Feb 2012 14:27:11 -0500
Date: Fri, 17 Feb 2012 20:27:04 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Matthew Garrett <mjg@redhat.com>
Cc: linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org, lenb@kernel.org
Subject: Re: [PATCH 1/3] ACPI: Provide config option to disable BIOS
 brightness changes on power events
Message-ID: <20120217192704.GB2707@elf.ucw.cz>
References: <1328282293-16551-1-git-send-email-mjg@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328282293-16551-1-git-send-email-mjg@redhat.com>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> The default ACPI behaviour is to instruct the BIOS to automatically change
> brightness on power events. This may be undesirable for distributions who
> manage brightness in userspace. Provide a config option that disables this
> behaviour and leaves brightness control up to the OS.

Should this be configured during runtime?

Like... when userspace power management starts, it disables this?
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
