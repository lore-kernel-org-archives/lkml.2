Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757335Ab0IGWOV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Sep 2010 18:14:21 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:60107 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756049Ab0IGWOQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Sep 2010 18:14:16 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=mgqvAsRgY5i2gna+tezp+oEZqrDonlGqAlvY62ggO6y5IlhOhJBGMQ3oqrrWPvAuUC
         XYwo9Sn59B1pqO5MwsHl29VenBo8pG7OMQJMnNBJRibl95P9am9V/HZTK7r3C4jiRWQ0
         /CkxwiCihFDoniWcc0z/aTC8MTtigmzN6vXFg=
Date: Tue, 7 Sep 2010 15:14:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Neil Leeder <nleeder@codeaurora.org>
Cc: "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Horace Fu <horace.fu@quantatw.com>, Hsin.Wu@quantatw.com,
        mcuos.com@gmail.com
Subject: Re: [PATCH 0/1] input: keyboard: add qci keyboard driver
Message-ID: <20100907221407.GA22259@core.coreip.homeip.net>
References: <4C7838DD.1020004@codeaurora.org>
 <201008271533.01542.dmitry.torokhov@gmail.com>
 <4C7BF6D2.5080501@codeaurora.org>
 <20100830215556.GC28865@core.coreip.homeip.net>
 <4C7D6C17.1070604@codeaurora.org>
 <20100901063430.GG23585@core.coreip.homeip.net>
 <4C8148C6.2010006@codeaurora.org>
 <20100903203717.GA6412@core.coreip.homeip.net>
 <4C86B567.8030804@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C86B567.8030804@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 07, 2010 at 05:57:59PM -0400, Neil Leeder wrote:
> On 9/3/2010 4:37 PM, Dmitry Torokhov wrote:
> >
> >Does this mean you are not interested in getting drivers for the current
> >generation of hardware to mainline?
> 
> Hi Dmitry,
> 
> That's correct - I don't think there is much future for the current
> hardware if we can come up with a cleaner solution for the new
> versions. 

Ah, OK, I see.

> I will test 0xF5 with the new hardware.  I think we may
> still need a new keyboard driver, just rewritten to have a serio
> backend.

It would be great if newer hardware could make use of the atkbd driver
(if it is going to use serio + PS/2 ports on the EC).

Thanks.

-- 
Dmitry
