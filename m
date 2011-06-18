Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751660Ab1FRR27 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Jun 2011 13:28:59 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:41203 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751241Ab1FRR25 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Jun 2011 13:28:57 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Sat, 18 Jun 2011 19:28:47 +0200
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
To: "Robert P. J. Day" <rpjday@crashcourse.ca>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, hughd@google.com,
        Randy Dunlap <rdunlap@xenotime.net>
Subject: Re: [PATCH] TMPFS: Expand "help" to explain value of
 TMPFS_POSIX_ACL
Message-ID: <20110618192847.62dc6d87@stein>
In-Reply-To: <alpine.DEB.2.02.1106180743040.17576@localhost6.localdomain6>
References: <alpine.DEB.2.02.1106180743040.17576@localhost6.localdomain6>
X-Mailer: Claws Mail 3.7.8 (GTK+ 2.22.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Jun 18 Robert P. J. Day wrote:
> +	  If you've selected TMPFS, you almost certainly want this option
> +	  as well since a number of user space features (ie., ALSA sound)
> +	  require POSIX ACL support under /dev to work properly.  In other

There are still many systems which do not use ACLs in /dev or anywhere
else at all.  Hence, "may require POSIX ACL support".

> +	  words, if you're not sure and you have no *compelling* reason to
> +	  deselect this feature, say Y.

The asterisks around compelling are unnecessary.

BTW, thanks for improving the Kconfig help texts.
-- 
Stefan Richter
-=====-==-== -==- =--=-
http://arcgraph.de/sr/
