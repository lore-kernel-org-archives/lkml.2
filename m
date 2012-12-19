Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804Ab2LSEGX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 23:06:23 -0500
Received: from mail-da0-f44.google.com ([209.85.210.44]:56614 "EHLO
	mail-da0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754265Ab2LSEGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 23:06:15 -0500
Date: Tue, 18 Dec 2012 20:09:07 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Chen Gang <gang.chen@asianux.com>
Cc: Paul Fulghum <paulkf@microgate.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-serial@vger.kernel.org
Subject: Re: [PATCH] synclink fix ldisc buffer argument
Message-ID: <20121219040907.GA22719@kroah.com>
References: <50B8DDAC.8070901@microgate.com>
 <50B90D0D.9040401@microgate.com>
 <20121202151332.3b6a6504@pyramind.ukuu.org.uk>
 <F6B8A325-7DBF-4623-B16C-CDC5642EFD16@microgate.com>
 <20121202181057.097012c6@pyramind.ukuu.org.uk>
 <989CB961-79F8-479B-B16C-41358A60AC94@microgate.com>
 <50BC0C84.4060802@asianux.com>
 <50BCCD4C.8050209@microgate.com>
 <50BEAA0E.9000603@asianux.com>
 <50D12521.8010808@asianux.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <50D12521.8010808@asianux.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 10:23:29AM +0800, Chen Gang wrote:
> Hello Paul Fulghum:
> 
> it seems you are very busy,
>   and can not get your reply for "checking length in function rx_get_buf".

You should always send patches, long emails like this about "potential"
issues are hard to handle, patches are best.

greg k-h
