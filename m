Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755472Ab0LDR2F (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Dec 2010 12:28:05 -0500
Received: from kroah.org ([198.145.64.141]:44570 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752508Ab0LDR2D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Dec 2010 12:28:03 -0500
Date: Sat, 4 Dec 2010 09:28:40 -0800
From: Greg KH <greg@kroah.com>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        torvalds@linux-foundation.org, stable@kernel.org,
        jason.wessel@windriver.com, Andi Kleen <andi@firstfloor.org>,
        lwn@lwn.net
Subject: Re: Announcement: Plans for v2.6.34-longterm
Message-ID: <20101204172840.GC10282@kroah.com>
References: <20101203210719.GB21223@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101203210719.GB21223@windriver.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 03, 2010 at 04:07:19PM -0500, Paul Gortmaker wrote:
> With that in mind, it is our intention to also maintain a 2.6.34
> longterm tree.  Jason and I work at Wind River, which already has
> released products based on v2.6.34, and as such it only makes sense
> to have a public long-term tree that others who are also based on
> 2.6.34 can make use of.

Other than Wind River, what other distros/userbases are using .34 as a
platform for their products?

And how long do you expect to be maintaining this .34 branch for?

curious,

greg k-h
