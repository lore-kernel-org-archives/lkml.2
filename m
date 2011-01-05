Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751590Ab1AERYY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Jan 2011 12:24:24 -0500
Received: from kroah.org ([198.145.64.141]:50882 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751260Ab1AERYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Jan 2011 12:24:23 -0500
Date: Wed, 5 Jan 2011 09:24:15 -0800
From: Greg KH <greg@kroah.com>
To: Eric B Munson <emunson@mgebm.net>
Cc: akpm@linux-foundation.org, caiqian@redhat.com, mel@csn.ul.ie,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org, stable@kernel.org
Subject: Re: [stable] [PATCH] Fix handling of parse errors in sysctl
Message-ID: <20110105172415.GA9689@kroah.com>
References: <1294247329-11682-1-git-send-email-emunson@mgebm.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1294247329-11682-1-git-send-email-emunson@mgebm.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 05, 2011 at 10:08:49AM -0700, Eric B Munson wrote:
> This patch is a candidate for stable.

That's nice, but not how you get patches into the stable tree, sorry.
Please read Documentation/stable_kernel_rules.txt for how to do this.

thanks,

greg k-h
