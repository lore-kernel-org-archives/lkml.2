Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752896Ab0HKOMj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Aug 2010 10:12:39 -0400
Received: from mail-pv0-f174.google.com ([74.125.83.174]:61249 "EHLO
	mail-pv0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752280Ab0HKOMi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Aug 2010 10:12:38 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=ufjOM/P09qWuHCAPKA4mL4P5zlHQzBHPuc0qoFk7XobvsdV/fLqyBU9HcU69OgrL4x
         V7u1Zzd1ijydgmVvPhWyVAyLNfl/LjfzeEsonRXKYi6Me0TXzn6OJ/5bMpbTJufOYHod
         tPnS8v2f0rqKeJYcV/sotBdyNIBAAC/I9pp+A=
Date: Wed, 11 Aug 2010 19:42:19 +0530
From: Rabin Vincent <rabin@rab.in>
To: Linus Walleij <linus.walleij@stericsson.com>
Cc: Dan Williams <dan.j.williams@intel.com>, linux-kernel@vger.kernel.org,
        Sascha Hauer <s.hauer@pengutronix.de>
Subject: Re: [PATCH] DMAENGINE: add a slave buffer prep call
Message-ID: <20100811141219.GA5846@debian>
References: <1281476766-7066-1-git-send-email-linus.walleij@stericsson.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1281476766-7066-1-git-send-email-linus.walleij@stericsson.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 10, 2010 at 11:46:06PM +0200, Linus Walleij wrote:
> This makes it possible for engines to implement slave transfers
> to be done to/from a simple kmalloc():ed memory buffer and not
> just from scatterlists.

Why is this needed?  Drivers can just pass in a single-entry scatterlist
to the existing API to achieve the same functionality, and a couple of
them already do so.

Rabin
