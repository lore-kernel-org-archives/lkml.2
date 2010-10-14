Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755948Ab0JNTlz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Oct 2010 15:41:55 -0400
Received: from kroah.org ([198.145.64.141]:58937 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755076Ab0JNTly (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Oct 2010 15:41:54 -0400
Date: Thu, 14 Oct 2010 12:40:17 -0700
From: Greg KH <greg@kroah.com>
To: Bob Beers <bob.beers@gmail.com>
Cc: gregkh@suse.de, napohybelskurwysynom2010@gmail.com,
        akpm@linux-foundation.org, mm-commits@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging/cxt1e1: fix mtu_max name pollution
Message-ID: <20101014194017.GA29426@kroah.com>
References: <1286920661.8951.4.camel@tjeff3.edgeaccess.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286920661.8951.4.camel@tjeff3.edgeaccess.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 12, 2010 at 05:57:41PM -0400, Bob Beers wrote:
> Rename 'max_mtu' to 'cxt1e1_max_mtu' to avoid multiple definition of `max_mtu'.
> 
> Signed-off-by: Bob Beers <bbeers@gmail.com>

For some reason, this patch doesn't apply at all.  What tree did you
make it against?

thanks,

greg k-h
