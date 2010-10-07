Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760632Ab0JGNtI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 09:49:08 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:26799 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab0JGNtG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 09:49:06 -0400
Date: Thu, 7 Oct 2010 15:48:58 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-i2c@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: Fix Kconfig dependencies
Message-ID: <20101007154858.299b0109@endymion.delvare>
In-Reply-To: <4CADCD24.90507@suse.cz>
References: <1286199093-3576-1-git-send-email-mmarek@suse.cz>
	<20101004180346.59b10af7@endymion.delvare>
	<20101004223020.GA14702@sepie.suse.cz>
	<20101005100349.73914574@endymion.delvare>
	<20101005155631.GA9399@sepie.suse.cz>
	<20101007152442.1901a630@endymion.delvare>
	<4CADCD24.90507@suse.cz>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 07 Oct 2010 15:37:40 +0200, Michal Marek wrote:
> On 7.10.2010 15:24, Jean Delvare wrote:
> > OK, I've applied this patch. I doubt I can get it in Linus' tree before
> > 2.6.36 is release though, my previous pull request wasn't even
> > acknowledged yet.
> 
> OK, thanks.
> 
> 
> > Then we will have to discuss about a better solution with Roman Zippel,
> > because what we have now is all but elegant. Will you start the
> > discussion, or should I?
> 
> Roman has been absent for a year and half :(. The closest thing to a
> kconfig maintainer is currently me...

I didn't know that. MAINTAINERS should be updated to reflect this.

-- 
Jean Delvare
