Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755301Ab0JETK5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 15:10:57 -0400
Received: from kroah.org ([198.145.64.141]:38956 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754172Ab0JETKz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 15:10:55 -0400
Date: Tue, 5 Oct 2010 12:02:09 -0700
From: Greg KH <greg@kroah.com>
To: Tracey Dent <tdent48227@gmail.com>
Cc: linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        sam@ravnborg.org
Subject: Re: [PATCH v3 12/20] Staging: rtl8192su: ieee80211: Makefile:
 cleaned up Makefile cflag lines
Message-ID: <20101005190209.GA3386@kroah.com>
References: <1286037489-28439-1-git-send-email-tdent48227@gmail.com>
 <1286037489-28439-12-git-send-email-tdent48227@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1286037489-28439-12-git-send-email-tdent48227@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 02, 2010 at 12:38:01PM -0400, Tracey Dent wrote:
> Changed to use the proper ccflags-y option
> 
> Signed-off-by: Tracey Dent <tdent48227@gmail.com>
> ---
>  drivers/staging/rtl8192su/ieee80211/Makefile |   10 +++++-----

This file is no longer in linux-next.

thanks,

greg k-h
