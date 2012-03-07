Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755662Ab2CGVnH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 16:43:07 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:47159 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752095Ab2CGVnD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 16:43:03 -0500
Date: Wed, 7 Mar 2012 13:42:58 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: Android Kernel Team <kernel-team@android.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL] staging: Android updates
Message-ID: <20120307214258.GA12190@kroah.com>
References: <1331156046.2191.185.camel@work-vm>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1331156046.2191.185.camel@work-vm>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 01:34:06PM -0800, John Stultz wrote:
> Hi Greg, 
> 	Just wanted to send along some Android updates to the staging-next tree
> so they can be queued for 3.4. I've pulled these from the
> common/android-3.3 branch, and made only some minor changes to keep
> everything in the staging dir and to avoid compile issues on x86.

Ick, I really don't like git pull requests for staging tree stuff at the
moment.  Besides, you didn't sign your pull request, so I couldn't take
it anyway :)

Can you just send these in email using 'git send-email' instead?  That
works with my workflow very easily.

This is especially going to be an issue as some of these patches
conflict with others I just applied in the past 24 hours, and I can fix
them up by hand easier using individual patches in email.

thanks,

greg k-h
