Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754542Ab1GFQBe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Jul 2011 12:01:34 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59337 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753754Ab1GFQBd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Jul 2011 12:01:33 -0400
Date: Wed, 6 Jul 2011 08:57:20 -0700
From: Greg KH <gregkh@suse.de>
To: "Prashant P. Shah" <pshah.mumbai@gmail.com>
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: msm: fixed style issues found by checkpatch.pl
Message-ID: <20110706155720.GA16625@suse.de>
References: <20110706074934.GA935@mail.fossee.in>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110706074934.GA935@mail.fossee.in>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 06, 2011 at 01:19:34PM +0530, Prashant P. Shah wrote:
> This is a patch to the msm drivers that fixes many style issues
> found by the checkpatch.pl tool
> - extra spaces
> - invalid code indent
> - extra braces
> - invalid comment style
> 
> Signed-off-by: Prashant P. Shah <pshah.mumbai@gmail.com>

How about one patch per thing you changed please?

So that would be one patch for fixing extra braces, one for extra
spaces, and so on.  That makes it easier to review.

greg k-h
