Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933396Ab0DHU1n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:27:43 -0400
Received: from kroah.org ([198.145.64.141]:42625 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933333Ab0DHU1f (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:27:35 -0400
Date: Thu, 8 Apr 2010 12:17:39 -0700
From: Greg KH <greg@kroah.com>
To: Chihau Chau <chihau@gmail.com>
Cc: gregkh@suse.de, pavel@ucw.cz, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Staging: dream: pmem: fix some code style issues
Message-ID: <20100408191739.GE31571@kroah.com>
References: <1267599191-10327-1-git-send-email-chihau@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1267599191-10327-1-git-send-email-chihau@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 03:53:11AM -0300, Chihau Chau wrote:
> From: Chihau Chau <chihau@gmail.com>
> 
> This fixes some code style issues like some braces {} deleted becouse
> are not necessary for a single statement blocks and to include KERN_
> facility level in the printk() functions.

This is already in the tree :(

thanks,

greg k-h
