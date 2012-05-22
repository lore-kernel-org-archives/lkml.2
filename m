Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932586Ab2EVUZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 May 2012 16:25:21 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:40242 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932524Ab2EVUZU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 May 2012 16:25:20 -0400
Date: Tue, 22 May 2012 13:24:53 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sameer Nanda <snanda@chromium.org>
Cc: len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH] power: add knob for printing device resume times
Message-ID: <20120522202453.GA30723@kroah.com>
References: <1337365643-29261-1-git-send-email-snanda@chromium.org>
 <1337714205-18038-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337714205-18038-1-git-send-email-snanda@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 22, 2012 at 12:16:45PM -0700, Sameer Nanda wrote:
> Added a new knob called /sys/powe/pm_print_times. Setting it to 1
> enables printing of time taken by devices to suspend and resume.
> Setting it to 0 disables this printing (unless overridden by
> initcall_debug kernel command line option).
> 
> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> cc: Greg KH <gregkh@linuxfoundation.org>
> cc: Rafael J. Wysocki <rjw@sisk.pl>
> cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  drivers/base/power/main.c  |    4 ++--
>  drivers/base/power/power.h |   11 +++++++++++
>  kernel/power/main.c        |   34 ++++++++++++++++++++++++++++++++++
>  3 files changed, 47 insertions(+), 2 deletions(-)

Not getting into if this patch is correct or not, it's obviously wrong
in that you are adding a new sysfs file to the system, yet you did not
add a Documentation/ABI/ file documenting exactly what this file does
and how to use it.

Please redo it with that added, and fix the obvious typo in the
changelog body as well :)

thanks,

greg k-h
