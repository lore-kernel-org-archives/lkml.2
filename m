Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933430Ab0D3Rx5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:53:57 -0400
Received: from kroah.org ([198.145.64.141]:54082 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933510Ab0D3Rxe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:53:34 -0400
Date: Thu, 29 Apr 2010 09:21:08 -0700
From: Greg KH <greg@kroah.com>
To: candyguitar@googlemail.com
Cc: gregkh@suse.de, jmm@debian.org, mithlesh@linsyssoft.com, svenne@krap.dk,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] Staging: wlan-ng: Fixed 80-character line coding
 style issues in p80211req.c
Message-ID: <20100429162108.GB30057@kroah.com>
References: <1268999858-17323-1-git-send-email-candyguitar@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1268999858-17323-1-git-send-email-candyguitar@googlemail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 19, 2010 at 11:57:38AM +0000, candyguitar@googlemail.com wrote:
> From: Candyguitar <candyguitar@candyguitar-laptop.(none)>
> 
> This is a patch for p80211req.c. An 'if' statement that spanned 80
> characters has been split onto 2 lines and one of the tabs preceding
> a comment has been removed.
> 
> Signed-off-by: Patrick Rooney <candyguitar@googlemail.com>
> ---
>  drivers/staging/wlan-ng/p80211req.c |    5 +++--

You already submitted this patch, and it's in the tree now, right?

thanks,

greg k-h
