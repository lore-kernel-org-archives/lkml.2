Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754543Ab1CQDG4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Mar 2011 23:06:56 -0400
Received: from mx1.redhat.com ([209.132.183.28]:19681 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752452Ab1CQDGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Mar 2011 23:06:54 -0400
Date: Wed, 16 Mar 2011 23:06:49 -0400
From: Dave Jones <davej@redhat.com>
To: Greg KH <gregkh@suse.de>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: fix reversed memset arguments in hv_mouse
Message-ID: <20110317030649.GA4343@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>, Greg KH <gregkh@suse.de>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20110317014059.GA31086@redhat.com>
 <20110317020545.GA2163@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110317020545.GA2163@suse.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 16, 2011 at 07:05:45PM -0700, Greg KH wrote:
 > On Wed, Mar 16, 2011 at 09:40:59PM -0400, Dave Jones wrote:
 > > size is 3rd arg, not the 2nd.
 > 
 > Do you just have a script that checks lkml for this?  :)

mutt hook. 

 > I thought checkpatch.pl caught these problems, I guess not.  Thanks for
 > the patch, I'll queue it up.
 
I thought so too. I'm sure I sent one in.  I'll resend it.

	Dave

