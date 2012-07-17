Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757450Ab2GQWvF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Jul 2012 18:51:05 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:59255 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754720Ab2GQWuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Jul 2012 18:50:40 -0400
Date: Tue, 17 Jul 2012 15:50:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: John Stultz <johnstul@us.ibm.com>
Cc: stable@vger.kernel.org, Prarit Bhargava <prarit@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 00/11] 3.0-stable: Fix for leapsecond deadlock &
 hrtimer/futex issue
Message-ID: <20120717225037.GA26986@kroah.com>
References: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1342546438-17534-1-git-send-email-johnstul@us.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 17, 2012 at 01:33:47PM -0400, John Stultz wrote:
> Here is backport of the leapsecond fixes to 3.0-stable. These are less
> straight forward, and should get closer review.

Thanks, all applied now.

greg k-h
