Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933336Ab0DHU1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Apr 2010 16:27:35 -0400
Received: from kroah.org ([198.145.64.141]:42607 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758762Ab0DHU1c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Apr 2010 16:27:32 -0400
Date: Thu, 8 Apr 2010 12:11:23 -0700
From: Greg KH <greg@kroah.com>
To: H Hartley Sweeten <hartleys@visionengravers.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>, ss@aao.gov.au
Subject: Re: [PATCH] staging/dt3155: fix build error caused by
 {write|read}l change
Message-ID: <20100408191123.GB31571@kroah.com>
References: <201003031124.06345.hartleys@visionengravers.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201003031124.06345.hartleys@visionengravers.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 03, 2010 at 11:24:06AM -0700, H Hartley Sweeten wrote:
> This fixes a build error caused by replacing {Write | Read}MReg with 
> {write | read}l.

Ick, can you merge this with your other patch so we don't have build
errors?  I just hit this and I had to drop all of your patches.

Can you respin all of them please?

thanks,

greg k-h
