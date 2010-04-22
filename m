Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754213Ab0DWAOs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Apr 2010 20:14:48 -0400
Received: from kroah.org ([198.145.64.141]:41018 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753864Ab0DWAOn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Apr 2010 20:14:43 -0400
Date: Thu, 22 Apr 2010 16:51:47 -0700
From: Greg KH <greg@kroah.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] firmware loader: use statically initialized data
 attribute
Message-ID: <20100422235147.GB4414@kroah.com>
References: <20100314074330.27035.38765.stgit@localhost.localdomain>
 <20100314074907.27035.41960.stgit@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100314074907.27035.41960.stgit@localhost.localdomain>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 13, 2010 at 11:49:07PM -0800, Dmitry Torokhov wrote:
> There is no reason why we are using a template for binary attribute
> and copying it into per-firmware data before registering. Using the
> original works as well and gets rid of the following lockdep
> compaint:

This patch isn't needed anymore, right?

thanks,

greg k-h
