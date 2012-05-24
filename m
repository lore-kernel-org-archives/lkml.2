Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932542Ab2EXK1R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 May 2012 06:27:17 -0400
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:41969 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752148Ab2EXK1Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 May 2012 06:27:16 -0400
Date: Thu, 24 May 2012 12:27:14 +0200
From: Pavel Machek <pavel@ucw.cz>
To: Sameer Nanda <snanda@chromium.org>
Cc: len.brown@intel.com, rjw@sisk.pl, gregkh@linuxfoundation.org,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] power: add knob for printing device resume times
Message-ID: <20120524102714.GA15990@elf.ucw.cz>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
 <1337714205-18038-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337714205-18038-1-git-send-email-snanda@chromium.org>
X-Warning: Reading this can be dangerous to your mental health.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 2012-05-22 12:16:45, Sameer Nanda wrote:
> Added a new knob called /sys/powe/pm_print_times. Setting it to 1
> enables printing of time taken by devices to suspend and resume.
> Setting it to 0 disables this printing (unless overridden by
> initcall_debug kernel command line option).

Did not we have nice module_param() interface that had kernel command
line parameter _and_ sysfs file created with .. one line IIRC?

Could that be used?

-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
