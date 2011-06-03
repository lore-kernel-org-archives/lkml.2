Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756559Ab1FCWgR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Jun 2011 18:36:17 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:37524 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756263Ab1FCWgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Jun 2011 18:36:16 -0400
X-Sasl-enc: c5vk2fUN97/wy8opqHUCQPjtgwJq3UIqFFo4MmT9lByy 1307140574
Date: Sat, 4 Jun 2011 07:32:13 +0900
From: Greg KH <greg@kroah.com>
To: Mike Frysinger <vapier@gentoo.org>
Cc: uclinux-dist-devel@blackfin.uclinux.org, Steven Miao <realmz6@gmail.com>,
        linux-kernel@vger.kernel.org, stable@kernel.org
Subject: Re: [stable] [PATCH] Blackfin: strncpy: fix handling of zero lengths
Message-ID: <20110603223213.GB9161@kroah.com>
References: <1307113762-3330-1-git-send-email-vapier@gentoo.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1307113762-3330-1-git-send-email-vapier@gentoo.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 03, 2011 at 11:09:22AM -0400, Mike Frysinger wrote:
> From: Steven Miao <realmz6@gmail.com>
> 
> The jump to 4f will cause the NUL padding loop to run at least one time,
> so if string length is zero just jump to the end.  Otherwise we wrongly
> write one NUL byte when size==0.
> 
> Signed-off-by: Steven Miao <realmz6@gmail.com>
> Signed-off-by: Mike Frysinger <vapier@gentoo.org>
> ---
>  arch/blackfin/lib/strncpy.S |    2 +-
>  1 files changed, 1 insertions(+), 1 deletions(-)
>


<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read Documentation/stable_kernel_rules.txt
for how to do this properly.

</formletter>
