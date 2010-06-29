Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755467Ab0F2Moo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jun 2010 08:44:44 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:32926 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753330Ab0F2Mom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jun 2010 08:44:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-type:content-disposition:in-reply-to
         :user-agent;
        b=kL5NXES0duODK0aso+9eqRM2QAaxVGELe+/biuI6fkd86aBnxBckhT3111UtR/FTr0
         4qWbk4FIqP8JA/ezrrwKfJmXqleITgrz/54Ous/UhjbK3elxFQjarjssh3I1SufBUWeI
         k6u6NZzvA8Vb8gbDW5rILteTFRtGhDw6KeDwI=
Date: Tue, 29 Jun 2010 14:42:58 +0200
From: Dan Carpenter <error27@gmail.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Kernel Janitors <kernel-janitors@vger.kernel.org>,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH 01/25] r852: remove casts from void*
Message-ID: <20100629123850.GO19184@bicker>
Mail-Followup-To: Dan Carpenter <error27@gmail.com>,
	Kulikov Vasiliy <segooon@gmail.com>,
	Kernel Janitors <kernel-janitors@vger.kernel.org>,
	linux-kernel@vger.kernel.org
References: <1277806498-30738-1-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277806498-30738-1-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 29, 2010 at 02:14:57PM +0400, Kulikov Vasiliy wrote:
> Remove unnesessary casts from void*.
> 

1) The subjects are not helpful.  This one should say something about
"mtd" but it doesn't.
2) These haven't been run through checkpatch.pl.  In fact, I can't be 
certain anyone looked at these patches when I see things like:

-    if((( lp = (struct wl_private *)dev->priv ) != NULL ) &&
-          !( lp->flags & WVLAN2_UIL_BUSY )) {
+    if((( lp = dev->priv ) != NULL ) &&
+       !( lp->flags & WVLAN2_UIL_BUSY )) {

On the recieving end, someone has to review every patch that gets merged.

regards,
dan carpenter

