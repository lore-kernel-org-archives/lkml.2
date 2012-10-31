Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423279Ab2JaQHL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 31 Oct 2012 12:07:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:36219 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423265Ab2JaQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 31 Oct 2012 12:07:07 -0400
Date: Wed, 31 Oct 2012 09:07:04 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Felipe Balbi <balbi@ti.com>
Cc: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH/Ver2] [trivial] usb: Fix typo in drivers/usb
Message-ID: <20121031160704.GB31804@kroah.com>
References: <1351695831-14294-1-git-send-email-standby24x7@gmail.com>
 <20121031150654.GA26934@arwen.pp.htv.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20121031150654.GA26934@arwen.pp.htv.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 31, 2012 at 05:06:54PM +0200, Felipe Balbi wrote:
> Hi,
> 
> On Thu, Nov 01, 2012 at 12:03:51AM +0900, Masanari Iida wrote:
> > Correct spelling typo in debug messages within drivers/usb.
> > 
> > Signed-off-by: Masanari Iida <standby24x7@gmail.com>
> > Acked-by: Felipe Balbi <balbi@ti.com>
> 
> Greg, since now this only touches the stuff I handle, I can apply this
> myself.

Ok, that makes it easy for me, thanks:

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
