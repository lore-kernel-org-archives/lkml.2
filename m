Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030330Ab2CGUGb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Mar 2012 15:06:31 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:53451 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030212Ab2CGUGa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Mar 2012 15:06:30 -0500
Date: Wed, 7 Mar 2012 12:06:26 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Xiachen Dong <xiachendong@hotmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: 2.6.36 and higher version kernel slower than 2.6.25.1 kernel?
Message-ID: <20120307200626.GA3086@kroah.com>
References: <BAY167-W124DBC204D9E95FC00BAA44BD560@phx.gbl>
 <20120307194728.GA26341@kroah.com>
 <BAY167-W127BF20C0952D601BC4381FBD560@phx.gbl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <BAY167-W127BF20C0952D601BC4381FBD560@phx.gbl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 07, 2012 at 02:59:35PM -0500, Xiachen Dong wrote:
> 
> Thanks for your reply.
> 
> There could be quite some code change from 2.6.25.1 to 2.6.36. What we
> are doing now is to find the first version starting from 2.6.25.1 that
> has the performance hit. Then we start comparing the code and see
> what's changed. Looks like 2.6.28.7 is OK.

'git bisect' will do all of this for you pretty quickly, I'd recommend
doing that (but start by saying that 2.6.28 is good, that will speed it
up.)

> Haven't tried 3.2.29 yet because 3.2.29 probably won't be available in
> the BSP from our board manufacturer in the near future. I'll try
> 3.2.29 tonight on X86 CPU  anyway and get you updated.

Why isn't the BSP upstream?  Any pointers to where the patch for it is,
to get that merged properly?

thanks,

greg k-h
