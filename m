Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755957Ab2JIN6h (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 09:58:37 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:37294 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754378Ab2JIN6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 09:58:33 -0400
Date: Tue, 9 Oct 2012 06:58:29 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Claudio Scordino <claudio@evidence.eu.com>
Cc: linux-usb@vger.kernel.org, Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH RESEND] umc-bus.c: fix usage of device_trylock
Message-ID: <20121009135829.GB5583@kroah.com>
References: <5073FA9D.8080501@evidence.eu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5073FA9D.8080501@evidence.eu.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 09, 2012 at 12:21:17PM +0200, Claudio Scordino wrote:
> Hi all.
> 
> I've not received any feedback about this patch, so I'm resending just
> to check if someone is going to take care of it.

It was sent in the middle of the merge window, when we are scrambling to
get other stuff done.  It's still in my queue and will be handled after
3.7-rc1 is out, and I've caught up on my travel.

thanks,

greg k-h
