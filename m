Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754366Ab1A0AuJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 19:50:09 -0500
Received: from wolverine01.qualcomm.com ([199.106.114.254]:58378 "EHLO
	wolverine01.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753561Ab1A0AuI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 19:50:08 -0500
X-IronPort-AV: E=McAfee;i="5400,1158,6238"; a="72120252"
Subject: Re: [PATCH] msm: smd: Add smd_pkt driver
From: Daniel Walker <dwalker@codeaurora.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: David Brown <davidb@codeaurora.org>,
        Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
In-Reply-To: <20110126153240.9cc6c2e2.akpm@linux-foundation.org>
References: <1292437675-11561-1-git-send-email-nvishwan@codeaurora.org>
	 <8yatygweqng.fsf@huya.qualcomm.com>
	 <20110126153240.9cc6c2e2.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 26 Jan 2011 16:49:39 -0800
Message-ID: <1296089379.29801.52.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-01-26 at 15:32 -0800, Andrew Morton wrote:
> On Tue, 25 Jan 2011 11:20:51 -0800
> David Brown <davidb@codeaurora.org> wrote:
> 
> > On Wed, Dec 15 2010, Niranjana Vishwanathapura wrote:
> > 
> > > Add smd_pkt driver which provides device interface
> > > to smd packet ports.
> > >
> > > Signed-off-by: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
> > > ---
> > >  drivers/char/Kconfig       |    8 +
> > >  drivers/char/Makefile      |    2 +
> > >  drivers/char/msm_smd_pkt.c |  466 ++++++++++++++++++++++++++++++++++++++++++++
> > >  3 files changed, 476 insertions(+), 0 deletions(-)
> > >  create mode 100644 drivers/char/msm_smd_pkt.c
> > 
> > Andrew, what's the proper destination for this change?  Should this go
> > into your tree?  Is there anything you want me to do with this change?
> > 
> 
> Looks OK, I grabbed it.
> 
> I read the entire email trying to work out what an "SMD" is.  Failed. 
> Oh well.

+       bool "MSM Shared Memory Driver (SMD)"
+       help
+         Support for the shared memory interface between the apps
+         processor and the baseband processor.  Provides access to
+         the "shared heap", as well as virtual serial channels
+         used to communicate with various services on the baseband
+         processor.

It's an an interface from the cpu running Linux, and the other processor
that co-exists with the one running Linux. They need to communicate for
certain reasons .. I _think_ something like sending a text message is
sent by communicating over this interface, or getting the phone to dial
a number, along with many other things.

Thats my take on it anyway.

Daniel

-- 

Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

