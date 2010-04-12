Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751488Ab0DLEvZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Apr 2010 00:51:25 -0400
Received: from kroah.org ([198.145.64.141]:46795 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750983Ab0DLEvY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Apr 2010 00:51:24 -0400
Date: Sun, 11 Apr 2010 21:50:12 -0700
From: Greg KH <greg@kroah.com>
To: Mahesh Kuruganti <maheshkuruganti@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: ZTEAC8710 Support with Device ID 0xffff
Message-ID: <20100412045012.GB30209@kroah.com>
References: <u2xed984c71004110151va8df2b03wecc49168a72640de@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <u2xed984c71004110151va8df2b03wecc49168a72640de@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 11, 2010 at 02:21:16PM +0530, Mahesh Kuruganti wrote:
> Here is the Patch that adds support for a Model of ZTE AC8710 with Device ID
> 0xffff the support is added into the Option Module.Thanks

So close...

Can you resend this, with a "Signed-off-by:" line as documented in the
file, Documentation/SubmittingPatches, and make the patch against
2.6.34-rc3 and not attach it, but put it inline?

thanks,

greg k-h
