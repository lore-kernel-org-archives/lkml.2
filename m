Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965011Ab2JXQGQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Oct 2012 12:06:16 -0400
Received: from mail.csclub.uwaterloo.ca ([129.97.134.52]:43024 "EHLO
	mail.csclub.uwaterloo.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752192Ab2JXQGP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Oct 2012 12:06:15 -0400
From: "Lennart Sorensen" <lsorense@csclub.uwaterloo.ca>
Date: Wed, 24 Oct 2012 12:06:13 -0400
To: Johan Hovold <jhovold@gmail.com>
Cc: linux-kernel@vger.kernel.org, =?utf-8?B?QmrDuHJu?= Mork <bjorn@mork.no>,
        linux@sierrawireless.com, linux-usb@vger.kernel.org,
        Greg KH <gregkh@linuxfoundation.org>
Subject: Re: Fix memory leak in sierra_release() (this time with
 signed-off-by)
Message-ID: <20121024160613.GR18610@csclub.uwaterloo.ca>
References: <20121024142309.GQ18610@csclub.uwaterloo.ca>
 <20121024145644.GB3131@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121024145644.GB3131@localhost>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 24, 2012 at 04:56:44PM +0200, Johan Hovold wrote:
> Good catch! I missed this one when I fixed a bunch of other memory
> leaks in the sierra with recent kernels:
> 
> 	http://marc.info/?l=linux-usb&m=135100550421848&w=2
> 
> I'll rebase my patch on top of this one as your patch should be
> backported to all stable kernels, whereas mine is only required for
> v3.6 and later.

Oh that looks useful.  I was trying to track down if there were more
leaks in the driver.  I just fixed the one that was most obvious to me.

-- 
Len Sorensen
