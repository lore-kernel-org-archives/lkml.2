Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753473Ab2JZE3I (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 00:29:08 -0400
Received: from linux-sh.org ([111.68.239.195]:40598 "EHLO linux-sh.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752700Ab2JZE3G (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 00:29:06 -0400
Date: Fri, 26 Oct 2012 13:28:33 +0900
From: Paul Mundt <lethal@linux-sh.org>
To: Kees Cook <keescook@chromium.org>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH 027/193] arch/sh: remove CONFIG_EXPERIMENTAL
Message-ID: <20121026042832.GB20205@linux-sh.org>
References: <1351022666-6960-1-git-send-email-keescook@chromium.org>
 <1351022666-6960-28-git-send-email-keescook@chromium.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1351022666-6960-28-git-send-email-keescook@chromium.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 23, 2012 at 01:01:40PM -0700, Kees Cook wrote:
> This config item has not carried much meaning for a while now and is
> almost always enabled by default. As agreed during the Linux kernel
> summit, remove it.
> 
> CC: Paul Mundt <lethal@linux-sh.org>
> CC: Tejun Heo <tj@kernel.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>

While there are cases where it is largely superfluous, we also have
plenty of cases in here that are genuinely experimental features and
generally shouldn't be enabled unless someone is prepared for some
hacking. We can of course replace this with an arch-specific option if
needed, but I disagree with suddenly making experimental features
suddenly appear to be anything other than what they are.
