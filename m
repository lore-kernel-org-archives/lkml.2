Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757181Ab1DWA4z (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Apr 2011 20:56:55 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:60500 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757054Ab1DWA4w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Apr 2011 20:56:52 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=EQ3mO7O4SVJtnR3FWpGYuXJXvGAn7eTsjaqsEi+64K6uGMDv3ArM1CgNBR8ql9Yyzj
         lXF/X0/N5U7xA/gSEQjc5c3D1BvmuSLrlkNPAjiLQA/Sky6SwsxJTJiZnYzg9uCUYyHt
         5Q1Ocom4SRKj22WlAu19eRZMDL+n98UeJ3dz8=
Date: Sat, 23 Apr 2011 02:56:47 +0200
From: Tejun Heo <htejun@gmail.com>
To: Mark Lord <kernel@teksavvy.com>
Cc: Bruce Stenning <b.stenning@indigovision.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-ide@vger.kernel.org" <linux-ide@vger.kernel.org>,
        Justin Maggard <jmaggard10@gmail.com>
Subject: Re: sata_mv port lockup on hotplug (kernel 2.6.38.2)
Message-ID: <20110423005647.GD1576@mtj.dyndns.org>
References: <C1438B59050E1B4C9482FF3266AD6BA32C7493559F@gretna.indigovision.com>
 <4D9CD275.9000002@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C749358D0@gretna.indigovision.com>
 <4D9FACC9.7020200@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772D9EB1@gretna.indigovision.com>
 <4DA5BCF3.5080205@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772DA491@gretna.indigovision.com>
 <4DA79134.1010508@teksavvy.com>
 <C1438B59050E1B4C9482FF3266AD6BA32C772DA5DD@gretna.indigovision.com>
 <4DA86606.308@teksavvy.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DA86606.308@teksavvy.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 15, 2011 at 11:36:38AM -0400, Mark Lord wrote:
> On 11-04-15 09:21 AM, Bruce Stenning wrote:
> ..
> > sata_mv 0000:00:04.0: Gen-II 32 slots 4 ports SCSI mode IRQ via INTx
> ..
> > 
> > I had noticed occasional messages similar to the following earlier in the week:
> > 
> > ata4.00: limiting speed to UDMA/100:PIO4
> 
> Ugh.   Tejun:  that's just plain silly.
> Why would we EVER EVER EVER fall back to "PIO" for SATA ???

Nah, it's just printing both DMA and PIO speed settings.  It's limited
to UDMA/100 not PIO4.

Thanks.

-- 
tejun
