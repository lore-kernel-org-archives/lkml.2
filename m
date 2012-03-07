Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030641Ab2CGWKq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 17:10:46 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:48442 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755457Ab2CGWKp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 17:10:45 -0500
Date: Wed, 7 Mar 2012 14:10:41 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Nick Kralevich <nnk@google.com>,
        Android Kernel Team <kernel-team@android.com>
Subject: Re: [PATCH 13/13] android: ram_console: honor dmesg_restrict
Message-ID: <20120307221041.GD16652@kroah.com>
References: <1331157503-3413-1-git-send-email-john.stultz@linaro.org>
 <1331157503-3413-14-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331157503-3413-14-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:58:23PM -0800, John Stultz wrote:
> From: Nick Kralevich <nnk@google.com>
> 
> The Linux kernel has a setting called dmesg_restrict. When true,
> only processes with CAP_SYSLOG can view the kernel dmesg logs. This
> helps prevent leaking of kernel information into user space.
> 
> On Android, it's possible to bypass these restrictions by viewing
> /proc/last_kmsg.
> 
> This change makes /proc/last_kmsg require the same permissions as
> dmesg.
> 
> Bug: 5555691

In what bugzilla does this bug number reference?  Random integers don't
do much for people when looking back at the history of things :)

thanks,

greg k-h
