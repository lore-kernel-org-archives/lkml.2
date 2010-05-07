Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752288Ab0EGAAR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 May 2010 20:00:17 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:26776 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751725Ab0EGAAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 May 2010 20:00:15 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,5974"; a="40506719"
Subject: Re: [PATCH] drivers: staging: dream: fix smd in makefile
From: Daniel Walker <dwalker@codeaurora.org>
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
       Pavel Machek <pavel@ucw.cz>
In-Reply-To: <20100506235433.GA4477@kroah.com>
References: <1273189739-1710-1-git-send-email-dwalker@codeaurora.org>
	 <20100506235433.GA4477@kroah.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 06 May 2010 17:00:01 -0700
Message-ID: <1273190401.20494.44.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.1 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2010-05-06 at 16:54 -0700, Greg KH wrote:
> On Thu, May 06, 2010 at 04:48:59PM -0700, Daniel Walker wrote:
> > Not sure about this one.. Cause if you apply this then some SMD files
> > don't compile anymore. There's some missing config options related to
> > AMSS.
> > 
> > NOT-Signed-off-by: Daniel Walker <dwalker@codeaurora.org>
> 
> Heh, I'm not going to apply this then :)
> 
> > CC: Greg KH <greg@kroah.com>
> > Cc: Pavel Machek <pavel@ucw.cz>
> > ---
> >  drivers/staging/dream/Makefile |    3 ++-
> 
> With the recent progression of your arch tree, and the
> wakelock/suspend-blocker stuff, what's the need for these files to still
> be in the staging directory at all?  Can't it be deleted and it go
> through your tree?

Yeah, all the smd stuff can .. The rest of it should stay for now I
think. I'm not ready to take on those other specific drivers, like the
camera etc..

Should I just send a patch to drop the whole SMD directory then?

Daniel

