Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753986Ab0DZXcZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Apr 2010 19:32:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:42130 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753349Ab0DZXcX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Apr 2010 19:32:23 -0400
Date: Tue, 27 Apr 2010 00:37:22 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Greg KH <greg@kroah.com>, linux-next@vger.kernel.org,
       linux-kernel@vger.kernel.org, Alan Cox <alan@linux.intel.com>
Subject: Re: linux-next: build warning after merge of the tty.current tree
Message-ID: <20100427003722.2bc89d10@lxorguk.ukuu.org.uk>
In-Reply-To: <20100427092346.12c4ecaa.sfr@canb.auug.org.au>
References: <20100427092346.12c4ecaa.sfr@canb.auug.org.au>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 27 Apr 2010 09:23:46 +1000
Stephen Rothwell <sfr@canb.auug.org.au> wrote:

> Hi Greg,
> 
> After merging the tty.current tree, today's linux-next build (x86_64
> allmodconfig) produced this warning:
> 
> drivers/char/isicom.c: In function 'isicom_open':
> drivers/char/isicom.c:875: warning: unused variable 'card'
> 
> Introduced by commit 746b212efb4664117612c7f43f880d230588d617 ("tty: Fix
> regressions in the char driver conversion").

I'll fix that tomorrow and send it to Greg
