Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab0CTNDZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Mar 2010 09:03:25 -0400
Received: from kroah.org ([198.145.64.141]:46685 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752501Ab0CTNDW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Mar 2010 09:03:22 -0400
Date: Sat, 20 Mar 2010 06:01:58 -0700
From: Greg KH <greg@kroah.com>
To: Marin Mitov <mitov@issp.bas.bg>
Cc: Scott Smedley <ss@aao.gov.au>, linux-kernel@vger.kernel.org
Subject: Re: [RFC] Yet another (third) dt3155 driver PCI/video4linux
	compliant
Message-ID: <20100320130158.GA13682@kroah.com>
References: <201003201118.36736.mitov@issp.bas.bg>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003201118.36736.mitov@issp.bas.bg>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 20, 2010 at 11:18:36AM +0200, Marin Mitov wrote:
> Hi Scott, Greg, all,
> 
> Here you will find a link to the source code for a dt3155 driver
> rewritten to be  PCI/video4linux compliant.
> 
> http://lfb.issp.bas.bg/~mitov/linux/dt3155v4l/
> 
> It works with xawtv (if the window is bigger than the acquired image).
> See 
> 
> http://lfb.issp.bas.bg/~mitov/linux/dt3155v4l/00README
> 
> for more details.
> 
> Any critics/comments will be appreciated.

Can you send it in patch form?  I can't really do anything with it like
this, sorry.

greg k-h
