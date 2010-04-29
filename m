Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933058Ab0D3RSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:18:50 -0400
Received: from kroah.org ([198.145.64.141]:39645 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932609Ab0D3RSd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:18:33 -0400
Date: Thu, 29 Apr 2010 10:35:55 -0700
From: Greg KH <greg@kroah.com>
To: Lars Lindley <lindley@coyote.org>
Cc: gregkh@suse.de, alan@linux.intel.com, o.hartmann@telovital.com,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: et131x: et1310_address_map.h Brace and space
 fix.
Message-ID: <20100429173555.GA13082@kroah.com>
References: <1270882537-16252-1-git-send-email-lindley@coyote.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1270882537-16252-1-git-send-email-lindley@coyote.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Apr 10, 2010 at 08:55:37AM +0200, Lars Lindley wrote:
> I fixed a space and a brace found by checkpatch.pl.
> 
> Signed-off-by: Lars Lindley <lindley@coyote.org>
> ---
>  drivers/staging/et131x/et1310_address_map.h |    5 ++---

This was already done by someone else, sorry :(

greg k-h
