Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932418Ab3AISLQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jan 2013 13:11:16 -0500
Received: from mail-da0-f53.google.com ([209.85.210.53]:60804 "EHLO
	mail-da0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932320Ab3AISLP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jan 2013 13:11:15 -0500
Date: Wed, 9 Jan 2013 10:11:11 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Davidlohr Bueso <davidlohr.bueso@hp.com>
Cc: linux-kernel@vger.kernel.org, Nitin Gupta <ngupta@vflare.org>
Subject: Re: [PATCH] staging: zsmalloc: comment zs_create_pool function
Message-ID: <20130109181111.GA29607@kroah.com>
References: <1357330440.1926.1.camel@buesod1.americas.hpqcorp.net>
 <1357754254.1800.2.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1357754254.1800.2.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 09:57:34AM -0800, Davidlohr Bueso wrote:
> ping?
> 
> On Fri, 2013-01-04 at 12:14 -0800, Davidlohr Bueso wrote:
> > Just as with zs_malloc() and zs_map_object(), it is worth
> > formally commenting the zs_create_pool() function.
> > 
> > Signed-off-by: Davidlohr Bueso <davidlohr.bueso@hp.com>
> > ---
> >  drivers/staging/zsmalloc/zsmalloc-main.c | 11 +++++++++++

I am currently digging out of a 3 week backlog of email due to vacation.
Staging patches, especially ones for zsmalloc and friends, are way on
the bottom of the priority list.  It's not lost, and will be gotten to
eventually, thanks for your patience.

greg k-h
