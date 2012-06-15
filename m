Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753783Ab2FOATc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Jun 2012 20:19:32 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:60251 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752494Ab2FOATa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Jun 2012 20:19:30 -0400
Date: Thu, 14 Jun 2012 17:19:24 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sameer Nanda <snanda@chromium.org>
Cc: rob@landley.net, len.brown@intel.com, pavel@ucw.cz, rjw@sisk.pl,
        linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: [PATCH v2] power: add knob for printing device resume times
Message-ID: <20120615001924.GA8874@kroah.com>
References: <20120522202453.GA30723@kroah.com>
 <1337791532-15820-1-git-send-email-snanda@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337791532-15820-1-git-send-email-snanda@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 23, 2012 at 09:45:32AM -0700, Sameer Nanda wrote:
> Added a new knob called /sys/power/pm_print_times. Setting it to 1
> enables printing of time taken by devices to suspend and resume.
> Setting it to 0 disables this printing (unless overridden by
> initcall_debug kernel command line option).
> 
> Signed-off-by: Sameer Nanda <snanda@chromium.org>
> cc: Greg KH <gregkh@linuxfoundation.org>
> cc: Rafael J. Wysocki <rjw@sisk.pl>
> cc: Steven Rostedt <rostedt@goodmis.org>
> ---
>  Documentation/ABI/testing/sysfs-power |   13 ++++++++++++
>  drivers/base/power/main.c             |    4 +-
>  drivers/base/power/power.h            |   11 ++++++++++
>  kernel/power/main.c                   |   34 +++++++++++++++++++++++++++++++++
>  4 files changed, 60 insertions(+), 2 deletions(-)

This patch fails against the linux-next tree, care to fix it up so that
I can apply it?

thanks,

greg k-h
