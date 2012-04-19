Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753992Ab2DSJPB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Apr 2012 05:15:01 -0400
Received: from anubis.se.axis.com ([195.60.68.12]:37634 "EHLO
	anubis.se.axis.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753430Ab2DSJO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Apr 2012 05:14:58 -0400
Date: Thu, 19 Apr 2012 11:14:50 +0200
From: Jesper Nilsson <jesper.nilsson@axis.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: Mikael Starvik <starvik@axis.com>,
        linux-cris-kernel <linux-cris-kernel@axis.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-next@vger.kernel.org" <linux-next@vger.kernel.org>
Subject: Re: [PATCH] cris: Remove old legacy "-traditional" flag from
	arch-v10/lib/Makefile
Message-ID: <20120419091450.GF16861@axis.com>
References: <1334779123-21957-1-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1334779123-21957-1-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 18, 2012 at 09:58:43PM +0200, Paul Gortmaker wrote:
> Most of these have been purged years ago.  This one silently lived
> on until commit 69349c2dc01c489eccaa4c472542c08e370c6d7e
> 
>     "kconfig: fix IS_ENABLED to not require all options to be defined"
> 
> In the above, we use some macro trickery to create a conditional that
> is valid in CPP and in C usage.  However that trickery doesn't sit
> well if you have the legacy "-traditional" flag enabled.  You'll get:
> 
>   AS      arch/cris/arch-v10/lib/checksum.o
> In file included from <command-line>:4:0:
> include/linux/kconfig.h:23:0: error: syntax error in macro parameter list
> make[2]: *** [arch/cris/arch-v10/lib/checksum.o] Error 1
> 
> Everything builds fine w/o "-traditional" so simply drop it from this
> location as well.
> 
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Agreed, I'll push this to the CRIS-tree. Thanks!

/^JN - Jesper Nilsson
-- 
               Jesper Nilsson -- jesper.nilsson@axis.com
