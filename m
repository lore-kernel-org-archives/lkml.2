Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754866Ab2K2PfG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Nov 2012 10:35:06 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47341 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754211Ab2K2PfE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Nov 2012 10:35:04 -0500
Date: Thu, 29 Nov 2012 07:36:39 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Abhijit Pawar <abhi.c.pawar@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 6/6] fs:sysfs pass NULL as second parameter for
 set_anon_super
Message-ID: <20121129153639.GA6639@kroah.com>
References: <1354170945-12211-1-git-send-email-abhi.c.pawar@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1354170945-12211-1-git-send-email-abhi.c.pawar@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Nov 29, 2012 at 12:05:45PM +0530, Abhijit Pawar wrote:
> set_anon_super does not use the second parameter in its implementation.
> So there is no need to pass on the second parameter.

Why not just remove the second parameter from the call then?

thanks,

greg k-h
