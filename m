Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030613Ab2CGWKK (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:10:10 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:37994 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752636Ab2CGWKH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:10:07 -0500
Date: Wed, 7 Mar 2012 14:10:02 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Colin Cross <ccross@android.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 11/13] android: persistent_trace: ftrace into
 persistent_ram
Message-ID: <20120307221002.GC16652@kroah.com>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
 <1331157503-3413-12-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331157503-3413-12-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:58:21PM -0800, John Stultz wrote:
> From: Colin Cross <ccross@android.com>
> 
> persistent_trace uses the ftrace infrastructure, but traces
> into a persistent_ram buffer instead of the regular ftrace
> ringbuffer.  After a reset or panic, the trace can be
> decoded with cat /sys/kernel/debug/persistent_trace.

Has this patch been run by the tracing kernel developers?

And what's the status on merging the persistent_ram stuff in with the
in-kernel api for this type of thing?  That should then get rid of this
separate tracing module, or at the least, let it be accepted directly by
the tracing developers and not need to go through staging, right?

thanks,

greg k-h
