Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932930Ab0EMUIF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 May 2010 16:08:05 -0400
Received: from kroah.org ([198.145.64.141]:60550 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757284Ab0EMUHW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 May 2010 16:07:22 -0400
Date: Thu, 13 May 2010 13:07:18 -0700
From: Greg KH <greg@kroah.com>
To: Piotr Hosowicz <piotr@hosowicz.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: General questiin about SYSFS
Message-ID: <20100513200718.GA18479@kroah.com>
References: <4BEC4B0D.8010102@example.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BEC4B0D.8010102@example.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 13, 2010 at 08:55:09PM +0200, Piotr Hosowicz wrote:
> Hello,
> 
> I have a simple question = I've heard rumours here and there that
> SYSFS is deprecated and forthcoming kernels won't use it

Nope, not true at all.  Where did you hear those rumors so that I can go
after them with a big stick and squash them?

> I even see some warning during boot.

What specific warning are you seeing?

> Is it true? And where to disable it in the config?

If you want to disable sysfs, you can, it's in the config file, but you
have to really know what you are doing otherwise you will usually end up
with a system that does not boot properly.

best of luck,

greg k-h
