Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754925Ab1AGAup (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:50:45 -0500
Received: from kroah.org ([198.145.64.141]:47142 "EHLO coco.kroah.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752137Ab1AGAuo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:50:44 -0500
Date: Thu, 6 Jan 2011 16:50:29 -0800
From: Greg KH <greg@kroah.com>
To: Dave Airlie <airlied@gmail.com>
Cc: linux-kernel@vger.kernel.org, Dave Airlie <airlied@redhat.com>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg KH <greg@suse.de>
Subject: Re: [PATCH 2/3] vt: fix issue when fbcon wants to takeover a
 second time.
Message-ID: <20110107005029.GA4257@kroah.com>
References: <1292895677-4242-1-git-send-email-airlied@gmail.com>
 <1292895677-4242-3-git-send-email-airlied@gmail.com>
 <AANLkTinsVH2pyPfEjEfm9JD=D8P12Q0Y56y+ZJbpYc06@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTinsVH2pyPfEjEfm9JD=D8P12Q0Y56y+ZJbpYc06@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 07, 2011 at 09:57:41AM +1000, Dave Airlie wrote:
> Hi Greg,
> 
> here is the patch I think you missed.

Ah, thanks, I did.  I'll queue this up for after .38-rc1 is out as it's
a bug fix.  It should go to -stable as well for .37 right?

thanks,

greg k-h
