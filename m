Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab0JENZN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 09:25:13 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45697 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751520Ab0JENZK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 09:25:10 -0400
Date: Tue, 5 Oct 2010 06:20:05 -0700
From: Greg KH <gregkh@suse.de>
To: Dan Carpenter <error27@gmail.com>, Rahul Ruikar <rahul.ruikar@gmail.com>,
        David Brownell <dbrownell@users.sourceforge.net>, nm127@freemail.hu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RESEND/PATCH] usb: gadget: goku_udc: Fix error path
Message-ID: <20101005132005.GB3548@suse.de>
References: <1286135940-2364-1-git-send-email-rahul.ruikar@gmail.com>
 <20101004122214.GA5692@bicker>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101004122214.GA5692@bicker>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 04, 2010 at 02:22:14PM +0200, Dan Carpenter wrote:
> On Mon, Oct 04, 2010 at 01:29:00AM +0530, Rahul Ruikar wrote:
> > call put_device() when device_register() fails.
> > 
> 
> Sorry I didn't realize what you were trying to do here.  This is not
> correct at all.
> 
> The right thing is to fix device_register() to call put_device() itself.
> It's a bit involved, because all the callers will need to be audited but
> someone is working on this I think.

No, no one is working on this, and no, it's not possible to make this
type of change to the driver core as discussed in the past due to the
way struct device can be embedded within another structure.

thanks,

greg k-h
