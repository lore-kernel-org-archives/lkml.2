Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751778Ab2GLEQJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 00:16:09 -0400
Received: from linux-sh.org ([111.68.239.195]:45873 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750939Ab2GLEQG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 00:16:06 -0400
Date: Thu, 12 Jul 2012 13:15:57 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: minyard@acm.org
Cc: linux-kernel@vger.kernel.org, linux-sh@vger.kernel.org,
        Corey Minyard <cminyard@mvista.com>
Subject: Re: [PATCH] SH: Convert out[bwl] macros to inline functions
Message-ID: <20120712041556.GB16064@linux-sh.org>
References: <1341866120-18640-1-git-send-email-minyard@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1341866120-18640-1-git-send-email-minyard@acm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 09, 2012 at 03:35:20PM -0500, minyard@acm.org wrote:
> From: Corey Minyard <cminyard@mvista.com>
> 
> The macros just called BUG(), but that results in unused variable
> warnings all over the place, like in the IPMI driver.  The build
> regression emails were annoying me, so here's the fix.  I have
> not even compile tested this, but it's rather obvious.
> 
> Signed-off-by: Corey Minyard <cminyard@mvista.com>

Builds fine, I've switched the port type to unsigned long, but it looks
good otherwise. Will queue it up for -rc7, thanks.
