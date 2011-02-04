Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752382Ab1BDVBi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 16:01:38 -0500
Received: from kroah.org ([198.145.64.141]:50608 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751431Ab1BDVBh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 16:01:37 -0500
Date: Fri, 4 Feb 2011 12:52:15 -0800
From: Greg KH <greg@kroah.com>
To: Timo von Holtz <tvh@informatik.uni-kiel.de>
Cc: gregkh@suse.de, mchehab@redhat.com, d.belimov@gmail.com,
        stefan.ringel@arcor.de, michel.ludwig@gmail.com, khali@linux-fr.org,
        c.pascoe@itee.uq.edu.au, ruslan@rpisarev.org.ua,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: tm6000: fixed some coding style issues
Message-ID: <20110204205215.GA28058@kroah.com>
References: <1296564547-26619-1-git-send-email-tvh@informatik.uni-kiel.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296564547-26619-1-git-send-email-tvh@informatik.uni-kiel.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 01, 2011 at 01:49:07PM +0100, Timo von Holtz wrote:
> Fixed all of the following coding style issues:
> 
> ERROR: return is not a function, parentheses are not required
> WARNING: __func__ should be used instead of gcc specific __FUNCTION__
> ERROR: trailing whitespace
> ERROR: spaces required around that '=' (ctx:VxV)
> WARNING: please, no space before tabs
> WARNING: please, no spaces at the start of a line
> ERROR: space required after that ',' (ctx:VxV)
> WARNING: space prohibited between function name and open parenthesis '('
> ERROR: spaces required around that '<' (ctx:VxV)
> ERROR: spaces required around that '==' (ctx:VxV)
> 
> Signed-off-by: Timo von Holtz <tvh@informatik.uni-kiel.de>

This needs to go to Mauro Carvalho Chehab <mchehab@redhat.com> as he
handles patches to this driver.

thanks,

greg k-h
