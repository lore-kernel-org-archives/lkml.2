Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757033Ab2IKGfy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 02:35:54 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:48769 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751331Ab2IKGfw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 02:35:52 -0400
Date: Tue, 11 Sep 2012 14:35:45 +0800
From: Shawn Guo <shawn.guo@linaro.org>
To: Matt Sealey <matt@genesi-usa.com>
Cc: Fabio Estevam <festevam@gmail.com>,
        Linux ARM Kernel Mailing List 
	<linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/4] efikamx: remove Efika MX-specific CHRGVBUS hack from
 the USB driver
Message-ID: <20120911063541.GA2481@S2101-09.ap.freescale.net>
References: <1343843371-14143-1-git-send-email-matt@genesi-usa.com>
 <1343843371-14143-5-git-send-email-matt@genesi-usa.com>
 <CAOMZO5CcUZ8NKM6uHkBB1Yo9MjeoBq9NzpOYwT1squM4TOgV7g@mail.gmail.com>
 <CAKGA1bnvu5WZMPc7Lv7ERDpaB=rz+bRHXg1ORiiwB3vWSK8dRQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAKGA1bnvu5WZMPc7Lv7ERDpaB=rz+bRHXg1ORiiwB3vWSK8dRQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 10, 2012 at 10:03:15AM -0500, Matt Sealey wrote:
> On Sun, Sep 9, 2012 at 10:00 PM, Fabio Estevam <festevam@gmail.com> wrote:
> > On Wed, Aug 1, 2012 at 2:49 PM, Matt Sealey <matt@genesi-usa.com> wrote:
> >> Since we're removing Efika MX support from the tree (for now), remove
> >> the hack present in the USB host driver since it will never run and
> >> isn't useful on any other systems.
> >>
> >> Signed-off-by: Matt Sealey <matt@genesi-usa.com>
> >
> > You should Cc linux-usb list and the USB maintainer on this one.
> 
> Good call, I actually thought I did that (git send-email is not my
> best friend this month).
> 
> Luckily though with the board removal patches in Shawn's tree going up
> at some point, this code can't be compiled anyway so this patch not
> making it in will not ruin anyone's day. I'll resubmit it in the near
> future but I'm not considering it top priority because of the
> abovementioned reason.
> 
Ok, I will drop this one from my tree, and send arch/arm/mach-imx
changes alone.  And then the patch can be resubmitted to linux-usb
tree later.

-- 
Regards,
Shawn
