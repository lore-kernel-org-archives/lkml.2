Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933006Ab0FURv2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 13:51:28 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:36313 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757931Ab0FURv0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 13:51:26 -0400
X-IronPort-AV: E=McAfee;i="5400,1158,6020"; a="44925271"
Subject: Re: [PATCH 1/3] msm: Add gpio register address mapping information.
From: Daniel Walker <dwalker@codeaurora.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Bryan Huntsman <bryanh@codeaurora.org>, Pavel Machek <pavel@ucw.cz>,
       Gregory Bean <gbean@codeaurora.org>, linux-arm-msm@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100621181851.53de5f62@lxorguk.ukuu.org.uk>
References: <1276888375-13221-1-git-send-email-gbean@codeaurora.org>
	 <1276888375-13221-2-git-send-email-gbean@codeaurora.org>
	 <20100619200249.GA2507@elf.ucw.cz> <4C1F9B58.6020302@codeaurora.org>
	 <20100621181851.53de5f62@lxorguk.ukuu.org.uk>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 21 Jun 2010 10:51:19 -0700
Message-ID: <1277142679.17092.37.camel@c-dwalke-linux.qualcomm.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-06-21 at 18:18 +0100, Alan Cox wrote:
> > > Yeah. Either this can be replaced with GPL, and it such case just do
> > > so, or it can not, and then it can not be applied to kernel.
> > > 
> > 
> > This is a standard BSD-style license so it's compatible w/ the GPL.  Thanks.
> 
> The kernel requires GPL, and its much much easier for everyone to state
> so explicitly to avoid future surprises (remember 4 clause BSD was once
> thought GPL compatible even by the FSF...)
> 
> If you want to make it clear it's also available BSD licensed in this
> form (at least until someone changes it) see the wording in files like
> drivers/char/random.c
> 
> That usually keeps all the lawyers happy.

I guess this is a fairly confusing issues .. I found a number of regular
BSD licenses in the kernel , many under include/linux/ ,

include/linux/nfs4_acl.h

in fact most of nfsd is BSD only, at least directly in the .c files.
There could be some statement someplace else that I missed.

include/net/ieee80211_radiotap.h
include/linux/quota.h

Just structures ..

Is it possible that no code header files can be BSD only? From looking
at the directory that is kind of what it looks like.

Daniel

-- 
Sent by a consultant of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum.

