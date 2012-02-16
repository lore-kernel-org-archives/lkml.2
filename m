Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754107Ab2BPTvX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Feb 2012 14:51:23 -0500
Received: from out5-smtp.messagingengine.com ([66.111.4.29]:44981 "EHLO
	out5-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751114Ab2BPTvV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Feb 2012 14:51:21 -0500
X-Sasl-enc: oa05+6H4teF0T7ucSA+r48NOQX+atplCq3HUPhmNJBEU 1329421880
Date: Thu, 16 Feb 2012 11:48:45 -0800
From: Greg KH <greg@kroah.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Stephen Warren <swarren@nvidia.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Shawn Guo <shawn.guo@freescale.com>,
        Thomas Abraham <thomas.abraham@linaro.org>,
        Dong Aisheng <dong.aisheng@linaro.org>,
        Rajendra Nayak <rajendra.nayak@linaro.org>,
        Haojian Zhuang <haojian.zhuang@marvell.com>,
        Barry Song <21cnbao@gmail.com>, Tony Lindgren <tony@atomide.com>,
        "linux-serial@vger.kernel.org" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH] serial/sirf: fixup for changes to pin control
Message-ID: <20120216194845.GB5480@kroah.com>
References: <1329417828-6005-1-git-send-email-linus.walleij@linaro.org>
 <74CDBE0F657A3D45AFBB94109FB122FF1790EC8791@HQMAIL01.nvidia.com>
 <CACRpkdavPdK13cJ-mdDXwbz3jNCSCzaa8LTdMDXOy4mi+pmdmw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdavPdK13cJ-mdDXwbz3jNCSCzaa8LTdMDXOy4mi+pmdmw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 16, 2012 at 08:39:39PM +0100, Linus Walleij wrote:
> On Thu, Feb 16, 2012 at 8:01 PM, Stephen Warren <swarren@nvidia.com> wrote:
> 
> > Should this patch be put into the pinctrl tree since that's where the
> > API changed, perhaps even squashed into the original commit to avoid
> > git bisect breakage, unless your branch needs to be stable?
> 
> Hm yeah I will for sure put it into the pinctrl tree.

Great, please feel free to add:
	Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

