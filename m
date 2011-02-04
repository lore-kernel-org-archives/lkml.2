Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753185Ab1BDVjW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:39:22 -0500
Received: from kroah.org ([198.145.64.141]:33340 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752057Ab1BDVjV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:39:21 -0500
Date: Fri, 4 Feb 2011 13:38:06 -0800
From: Greg KH <greg@kroah.com>
To: Julia Lawall <julia@diku.dk>
Cc: linux-kernel@vger.kernel.org
Subject: Re: request_region/release_resource
Message-ID: <20110204213806.GB1336@kroah.com>
References: <Pine.LNX.4.64.1102032124320.27852@ask.diku.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.1102032124320.27852@ask.diku.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 03, 2011 at 09:25:15PM +0100, Julia Lawall wrote:
> Is there any circumstance in which it is ok to call release_resource on 
> the result of calling request(_mem)_region?  One issue is that 
> release_resource doesn't free its argument, but then what if the call to 
> release_resource is followed by a call to kfree?

Ick, not nice things I think :(

Care to fix it up?

thanks,

greg k-h
