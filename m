Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754386Ab1AZXku (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jan 2011 18:40:50 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46936 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754147Ab1AZXkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jan 2011 18:40:49 -0500
Date: Wed, 26 Jan 2011 15:32:40 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: David Brown <davidb@codeaurora.org>
Cc: Niranjana Vishwanathapura <nvishwan@codeaurora.org>,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH] msm: smd: Add smd_pkt driver
Message-Id: <20110126153240.9cc6c2e2.akpm@linux-foundation.org>
In-Reply-To: <8yatygweqng.fsf@huya.qualcomm.com>
References: <1292437675-11561-1-git-send-email-nvishwan@codeaurora.org>
	<8yatygweqng.fsf@huya.qualcomm.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Jan 2011 11:20:51 -0800
David Brown <davidb@codeaurora.org> wrote:

> On Wed, Dec 15 2010, Niranjana Vishwanathapura wrote:
> 
> > Add smd_pkt driver which provides device interface
> > to smd packet ports.
> >
> > Signed-off-by: Niranjana Vishwanathapura <nvishwan@codeaurora.org>
> > ---
> >  drivers/char/Kconfig       |    8 +
> >  drivers/char/Makefile      |    2 +
> >  drivers/char/msm_smd_pkt.c |  466 ++++++++++++++++++++++++++++++++++++++++++++
> >  3 files changed, 476 insertions(+), 0 deletions(-)
> >  create mode 100644 drivers/char/msm_smd_pkt.c
> 
> Andrew, what's the proper destination for this change?  Should this go
> into your tree?  Is there anything you want me to do with this change?
> 

Looks OK, I grabbed it.

I read the entire email trying to work out what an "SMD" is.  Failed. 
Oh well.

