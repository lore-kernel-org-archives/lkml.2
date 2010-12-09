Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756312Ab0LIKeU (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Dec 2010 05:34:20 -0500
Received: from ist.d-labs.de ([213.239.218.44]:51693 "EHLO mx01.d-labs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755940Ab0LIKeT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Dec 2010 05:34:19 -0500
Date: Thu, 9 Dec 2010 11:34:16 +0100
From: Florian Mickler <florian@mickler.org>
To: Ben Hutchings <bhutchings@solarflare.com>
Cc: Asbjoern Sloth Toennesen <asbjorn@asbjorn.biz>,
        e1000-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH 6/7] e1000e: cleanup: swap arguments to avoid checkpatch
 errors
Message-ID: <20101209113416.66baf7ac@schatten.dmk.lab>
In-Reply-To: <1291865548.19763.1.camel@localhost>
References: <1291862457-16671-1-git-send-email-asbjorn@asbjorn.biz>
	<1291862457-16671-7-git-send-email-asbjorn@asbjorn.biz>
	<1291865548.19763.1.camel@localhost>
X-Mailer: Claws Mail 3.7.6cvs31 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 09 Dec 2010 03:32:28 +0000
Ben Hutchings <bhutchings@solarflare.com> wrote:

> On Thu, 2010-12-09 at 02:40 +0000, Asbjoern Sloth Toennesen wrote:
> > Swap argument order in order to avoid checkpatch treating it as an
> > unary operation, instead of an binary one, and obtain consistency
> > with the 3 other similar assignments in netdev.c (tdlen & rdlen).
> > 
> > This patch fixes 3 checkpatch errors.
> 
> You have got to be kidding.  If the checkpatch warning offends you, fix
> the bug in checkpatch instead of changing perfectly good code.
> 
> Ben.

That bug is fixed already:
 https://patchwork.kernel.org/patch/299172/

Andrew picked it up.

Regards,
Flo
