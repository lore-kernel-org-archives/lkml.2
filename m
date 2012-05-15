Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965004Ab2EOPLA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 11:11:00 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:44828 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2EOPK5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 11:10:57 -0400
Date: Tue, 15 May 2012 08:10:50 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Jeffrin Jose <ahiliation@yahoo.co.in>
Cc: mdharm-usb@one-eyed-alien.net, linux-kernel@vger.kernel.org
Subject: Re: styling fixes in drivers/usb/storage/usb.c
Message-ID: <20120515151050.GA23916@kroah.com>
References: <20120515143950.GA4654@debian.Jeff>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120515143950.GA4654@debian.Jeff>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 15, 2012 at 08:09:50PM +0530, Jeffrin Jose wrote:
> hello ,
> 
> worked on styling fixes in drivers/usb/storage/usb.c
> 
> 
> >From 67edcc16dffc6f05f8bad70590e4175b7aeaa945 Mon Sep 17 00:00:00 2001
> From: Jeffrin Jose <ahiliation@yahoo.co.in>
> Date: Tue, 15 May 2012 19:42:31 +0530
> Subject: [PATCH 2/2] drivers:Fixed several coding style issues in
>  drivers/usb/storage/usb.c

Please just use git send-email to send this, so I don't have to edit
out your "hello..." lines.

> 
> - Fixed trailing white space issues.
> - Fixed C99 comment issue.
> - Fixed keyword related space issues.
> in drivers/usb/storage/usb.c

You did 3 different things here, so please, make 3 different patches.
Remember, only do one thing at a time.

Care to redo this and resend these patches?

thanks,

greg k-h
