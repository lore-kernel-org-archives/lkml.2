Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752845Ab1CQCEq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 22:04:46 -0400
Received: from cantor.suse.de ([195.135.220.2]:34861 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752727Ab1CQCEm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 22:04:42 -0400
Date: Wed, 16 Mar 2011 19:05:45 -0700
From: Greg KH <gregkh@suse.de>
To: Dave Jones <davej@redhat.com>, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fix reversed memset arguments in hv_mouse
Message-ID: <20110317020545.GA2163@suse.de>
References: <20110317014059.GA31086@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317014059.GA31086@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 09:40:59PM -0400, Dave Jones wrote:
> size is 3rd arg, not the 2nd.

Do you just have a script that checks lkml for this?  :)

I thought checkpatch.pl caught these problems, I guess not.  Thanks for
the patch, I'll queue it up.

greg k-h
