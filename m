Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757233Ab2CZUs0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Mar 2012 16:48:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:35306 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757131Ab2CZUsX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Mar 2012 16:48:23 -0400
Date: Mon, 26 Mar 2012 13:48:21 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Michal Marek <mmarek@suse.cz>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>, sboyd@codeaurora.org,
        kernel-janitors@vger.kernel.org, gregkh@linuxfoundation.org,
        viro@zeniv.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] scripts/coccinelle/api/simple_open.cocci: semantic
 patch for simple_open()
Message-Id: <20120326134821.fb74a5b4.akpm@linux-foundation.org>
In-Reply-To: <20120326204407.GC10259@sepie.suse.cz>
References: <1331657917-4552-1-git-send-email-Julia.Lawall@lip6.fr>
	<20120326204407.GC10259@sepie.suse.cz>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 26 Mar 2012 22:44:07 +0200
Michal Marek <mmarek@suse.cz> wrote:

> On Tue, Mar 13, 2012 at 05:58:37PM +0100, Julia Lawall wrote:
> > From: Julia Lawall <Julia.Lawall@lip6.fr>
> > 
> > Find instances of an open-coded simple_open() and replace them
> > with calls to simple_open().
> > 
> > Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>
> > Reported-by: Stephen Boyd <sboyd@codeaurora.org>
> 
> Thanks, applied to kbuild.git#misc now.
> 

That's a bit premature, as simple_open() isn't upstream yet.


