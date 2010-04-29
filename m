Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933682Ab0D3Rxp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 30 Apr 2010 13:53:45 -0400
Received: from kroah.org ([198.145.64.141]:54080 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933668Ab0D3Rxd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 30 Apr 2010 13:53:33 -0400
Date: Thu, 29 Apr 2010 09:38:24 -0700
From: Greg KH <greg@kroah.com>
To: Kenji Toyama <kenji.toyama@gmail.com>
Cc: gregkh@suse.de, devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] Staging: wlags49_h2: Fix coding style issues
Message-ID: <20100429163824.GB5257@kroah.com>
References: <1269836398-13657-1-git-send-email-kenji.toyama@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1269836398-13657-1-git-send-email-kenji.toyama@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 29, 2010 at 03:19:58PM +1100, Kenji Toyama wrote:
> Fixed lots of coding style issues. There is one left warning about
> CVS markers, but I think it's better to leave as the original author
> wanted.
> Signed-off-by: Daniel Kenji Toyama <kenji.toyama@gmail.com>
> ---
>  drivers/staging/wlags49_h2/dhf.c |  372 +++++++++++++++++++++-----------------

This no longer applies cleanly against the linux-next tree.  Can you
respin it and resend it?

thanks,

greg k-h
