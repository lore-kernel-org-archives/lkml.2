Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754414Ab2GLFnL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jul 2012 01:43:11 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:53032 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752090Ab2GLFnJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jul 2012 01:43:09 -0400
Message-ID: <1342071788.1970.18.camel@joe2Laptop>
Subject: Re: [PATCH v3] panel: Use pr_err(...) rather than printk(KERN_ERR
 ...)
From: Joe Perches <joe@perches.com>
To: Ryan Mallon <rmallon@gmail.com>
Cc: Toshiaki Yamane <yamanetoshi@gmail.com>, greg@kroah.com, willy@meta-x.org,
        linux-kernel@vger.kernel.org
Date: Wed, 11 Jul 2012 22:43:08 -0700
In-Reply-To: <4FFE5F0F.8020904@gmail.com>
References: <1342060541-9648-1-git-send-email-yamanetoshi@gmail.com>
	 <4FFE5F0F.8020904@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2- 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-12 at 15:22 +1000, Ryan Mallon wrote:
> On 12/07/12 12:35, Toshiaki Yamane wrote:
> > This change is inspired by checkpatch.
> 
> Your changelog needs to describe all of the changes you are making. The
> subject line only describes one. This patch is doing the following:
> 
>  - Converting printk(KERN_ERR to pr_err
>  - Adding __func__ prefixes to printk lines
>  - Refactoring split printk strings onto a single line
> 
> There are a few other printks in this file which could be converted to
> pr_* to make the code more consistent. Perhaps a follow up patch?
> 
> Typically for a sub-sequent version of a patch/series you should list
> the changes since the last round. Put these below the --- so that they
> don't become part of the change log, e.g.:
> 
>   Signed-off-by: Your name/email here
>   ---
> 
>   Changes since v2:
>     - Some stuff
> 
>   Changes since v1:
>     - Some other stuff
> 
> Some more comments below.

And ideally cc the people that gave you notes/comments
on your previous patches too.

