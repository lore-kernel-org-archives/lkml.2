Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754203Ab1BCWUt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 17:20:49 -0500
Received: from kroah.org ([198.145.64.141]:59574 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754138Ab1BCWUr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 17:20:47 -0500
Date: Thu, 3 Feb 2011 14:13:46 -0800
From: Greg KH <greg@kroah.com>
To: Mandeep Singh Baines <msb@chromium.org>
Cc: gregkh@suse.de, rjw@sisk.pl, mingo@redhat.com, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-pm@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, linux-mm@kvack.org
Subject: Re: [PATCH 4/6] TTY: use appropriate printk priority level
Message-ID: <20110203221346.GA477@kroah.com>
References: <20110125235700.GR8008@google.com>
 <1296084570-31453-5-git-send-email-msb@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296084570-31453-5-git-send-email-msb@chromium.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 26, 2011 at 03:29:28PM -0800, Mandeep Singh Baines wrote:
> printk()s without a priority level default to KERN_WARNING. To reduce
> noise at KERN_WARNING, this patch set the priority level appriopriately
> for unleveled printks()s. This should be useful to folks that look at
> dmesg warnings closely.
> 
> Signed-off-by: Mandeep Singh Baines <msb@chromium.org>

This doesn't apply to the latest linux-next tree, care to resend it
after refreshing it?

thanks,

greg k-h
