Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755559Ab0C3Uc0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Mar 2010 16:32:26 -0400
Received: from kroah.org ([198.145.64.141]:50783 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751643Ab0C3UcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Mar 2010 16:32:24 -0400
Date: Tue, 30 Mar 2010 13:05:22 -0700
From: Greg KH <greg@kroah.com>
To: Stefan Bader <stefan.bader@canonical.com>
Cc: linux-kernel@vger.kernel.org, stable-commits@vger.kernel.org,
       gregkh@suse.de, davem@davemloft.net, stable@kernel.org
Subject: Re: [stable] patch sparc64-make-prom-entry-spinlock-nmi-safe.patch
	added to 2.6.32-stable tree
Message-ID: <20100330200522.GD1693@kroah.com>
References: <12689584863184@kroah.org> <4BB1E98E.9050702@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BB1E98E.9050702@canonical.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Mar 30, 2010 at 02:07:42PM +0200, Stefan Bader wrote:
> This converted the raw_spinlock usage which is used in the upstream patch but
> not available in 2.6.32 to normal spinlock usage. Should it get annotated to
> document that?

why, you obviously figured that out :)

It's not the normal thing to do for backports otherwise we would be here
all day long...

thanks,

greg k-h
