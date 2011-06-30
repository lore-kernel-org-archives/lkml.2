Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964Ab1F3FWX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jun 2011 01:22:23 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:33153 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752705Ab1F3FWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jun 2011 01:22:17 -0400
X-Sasl-enc: nnwOEego6ulxtwZUiqP6roN0Bo1S9sizTf/kV+eAJOLd 1309411336
Date: Wed, 29 Jun 2011 22:21:56 -0700
From: Greg KH <greg@kroah.com>
To: Tanya Brokhman <tlinder@codeaurora.org>
Cc: balbi@ti.com, linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ablay@codeaurora.org, "'open list'" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 1/2] usb: gadget: add max_speed to usb_composite_driver
Message-ID: <20110630052156.GA24087@kroah.com>
References: <1309350899-23868-1-git-send-email-tlinder@codeaurora.org>
 <1309350899-23868-2-git-send-email-tlinder@codeaurora.org>
 <20110629123826.GQ2760@legolas.emea.dhcp.ti.com>
 <051801cc365a$73187140$594953c0$@org>
 <20110629124822.GS2760@legolas.emea.dhcp.ti.com>
 <055801cc3681$d080ba00$71822e00$@org>
 <20110629194126.GA6057@legolas.emea.dhcp.ti.com>
 <05b101cc36e4$9067d8f0$b1378ad0$@org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <05b101cc36e4$9067d8f0$b1378ad0$@org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 30, 2011 at 08:14:15AM +0300, Tanya Brokhman wrote:
> Good morning Felipe,
> 
> > > I went over the emails and all is ok. Thanks!
> > > One question: Greg/Alan mentioned that the compilation warning should
> > > be fixed by __maybe_unused. I wasn't aware such thing existed. Just
> > > looked it up.
> > > Do you want me to send you a patch that fixes that or have you done
> > it
> > > already and I missed it again :) ?
> > 
> > Oops, I didn't. You can send a differential patch (just this change in
> > particular) and I'll merge into the original.
> 
> Just emailed you the fixing patch.
> Just one thing. Greg already merged the patch that caused the compilation
> warning into his tree so perhaps you can't merge the fix into the original
> patch and need to post the fix as a different patch....

Nope, you can't, I need just a single patch that resolves this.  I'll
queue up the patch you just sent, thanks.

greg k-h
