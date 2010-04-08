Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933290Ab0DHU1d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:27:33 -0400
Received: from kroah.org ([198.145.64.141]:42605 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755333Ab0DHU1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:27:32 -0400
Date: Thu, 8 Apr 2010 12:07:12 -0700
From: Greg KH <greg@kroah.com>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: staging: dream: pmem: fix some code style issues
Message-ID: <20100408190712.GA4890@kroah.com>
References: <1267487415-22061-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267487415-22061-1-git-send-email-chihau@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 01, 2010 at 08:50:15PM -0300, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues like some braces {} deleted becouse
> are not necessary for a single statement blocks and to include KERN_
> facility level in the printk() functions.
> 
> Signed-off-by: Chihau Chau <chihau@gmail.com>

Sorry, someone else already did this change to the tree.

greg k-h
