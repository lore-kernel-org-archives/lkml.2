Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab0GHUQo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jul 2010 16:16:44 -0400
Received: from kroah.org ([198.145.64.141]:58249 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755008Ab0GHUQZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jul 2010 16:16:25 -0400
Date: Thu, 8 Jul 2010 13:11:13 -0700
From: Greg KH <greg@kroah.com>
To: Kulikov Vasiliy <segooon@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@suse.de>, Lior Dotan <liodot@gmail.com>,
       charrer@alacritech.com, Denis Kirjanov <kirjanov@gmail.com>,
       "David S. Miller" <davem@davemloft.net>, Jiri Pirko <jpirko@redhat.com>,
       devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] staging: slicoss: Move NULL pointer assertion to
 else branch
Message-ID: <20100708201113.GA2329@kroah.com>
References: <1277644847-16292-1-git-send-email-segooon@gmail.com>
 <1277644847-16292-3-git-send-email-segooon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1277644847-16292-3-git-send-email-segooon@gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 27, 2010 at 05:20:45PM +0400, Kulikov Vasiliy wrote:
> Move NULL pointer assertion to else branch because it can
> become NULL only here.
> 

This patch doesn't apply on the linux-next tree :(

thanks,

greg k-h
