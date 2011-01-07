Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755146Ab1AGAwk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 19:52:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:59948 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753716Ab1AGAwj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 19:52:39 -0500
Subject: Re: [PATCH 2/3] vt: fix issue when fbcon wants to takeover a
 second time.
From: Dave Airlie <airlied@redhat.com>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@suse.de>
In-Reply-To: <20110107005029.GA4257@kroah.com>
References: <1292895677-4242-1-git-send-email-airlied@gmail.com>
	 <1292895677-4242-3-git-send-email-airlied@gmail.com>
	 <AANLkTinsVH2pyPfEjEfm9JD=D8P12Q0Y56y+ZJbpYc06@mail.gmail.com>
	 <20110107005029.GA4257@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 07 Jan 2011 10:52:25 +1000
Message-ID: <1294361545.8921.3.camel@clockmaker-el6>
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2011-01-06 at 16:50 -0800, Greg KH wrote:
> On Fri, Jan 07, 2011 at 09:57:41AM +1000, Dave Airlie wrote:
> > Hi Greg,
> > 
> > here is the patch I think you missed.
> 
> Ah, thanks, I did.  I'll queue this up for after .38-rc1 is out as it's
> a bug fix.  It should go to -stable as well for .37 right?

Yup, sounds like it should.

Dave.

