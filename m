Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754103Ab0FWW2i (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jun 2010 18:28:38 -0400
Received: from kroah.org ([198.145.64.141]:37748 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753883Ab0FWW1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jun 2010 18:27:36 -0400
Date: Wed, 23 Jun 2010 15:18:49 -0700
From: Greg KH <greg@kroah.com>
To: Gustavo Silva <silvagustavosilva@gmail.com>
Cc: gregkh@suse.de, alan@linux.intel.com, devel@driverdev.osuosl.org,
       linux-kernel@vger.kernel.org,
       Gustavo Silva <silvagustavo@users.sourceforge.net>
Subject: Re: [PATCH] Staging: memrar: fix coding style issues in
 memrar_handler.c
Message-ID: <20100623221849.GA15093@kroah.com>
References: <1277264253-10583-1-git-send-email-silvagustavo@users.sourceforge.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277264253-10583-1-git-send-email-silvagustavo@users.sourceforge.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jun 22, 2010 at 10:37:33PM -0500, Gustavo Silva wrote:
> This is a patch to the memrar_handler.c file that fixes up the following
> issues:
> 
> ERROR: trailing whitespace
> ERROR: code indent should use tabs where possible
> WARNING: please, no space before tabs

Sorry, someone just sent this one in and I applied it yesterday :(

Care to find some other code in here to clean up?

greg k-h
