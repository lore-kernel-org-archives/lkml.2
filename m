Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753118Ab1EJWn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 May 2011 18:43:56 -0400
Received: from kroah.org ([198.145.64.141]:52260 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752319Ab1EJWnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 May 2011 18:43:55 -0400
Date: Tue, 10 May 2011 15:39:08 -0700
From: Greg KH <greg@kroah.com>
To: Jason Stubbs <jasonbstubbs@gmail.com>
Cc: Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] platform: fix samsung brightness min/max calculations
Message-ID: <20110510223908.GA16989@kroah.com>
References: <201104201358.50443.jasonbstubbs@gmail.com>
 <201104281855.50572.jasonbstubbs@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201104281855.50572.jasonbstubbs@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 28, 2011 at 06:55:50PM +1000, Jason Stubbs wrote:
> Not sure of the "bump" process, so I'll just go over each part of the patch.
> 
> Note that all the changes only affect the sabi_config where min_brightness
> is 1 so you might not see in difference on your hardware.

This isn't needed anymore due to your other patch superseeding it,
right?

thanks,

greg k-h
