Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752030Ab0DPEVQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Apr 2010 00:21:16 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:52757 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751740Ab0DPEVL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Apr 2010 00:21:11 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=DcgDTYum9v2dOoOxytp+Ndfxx012XlTeybfLj8VZ7XEsgySbtJVziEgCub+IEbLppT
         IWofeYfMmHj4RHxhnEZKOilXsESkWCsr9iOVg8qfEZP0B09rdhad7hb6qNkZ9K5gSz1d
         HjxJJP/A+njJJZUcSACQePc5B+EEpPcaiyeWY=
Date: Thu, 15 Apr 2010 21:21:04 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Rafi Rubin <rafi@seas.upenn.edu>
Cc: Alan Cox <alan@linux.intel.com>, linux-i2c@vger.kernel.org,
       khali@linux-fr.org, linux-input@vger.kernel.org,
       linux-kernel@vger.kernel.org
Subject: Re: your mail
Message-ID: <20100416042104.GA20916@core.coreip.homeip.net>
References: <20100414125234.23507.42816.stgit@localhost.localdomain>
 <20100414231604.GA12281@core.coreip.homeip.net>
 <4BC7A422.7050601@seas.upenn.edu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4BC7A422.7050601@seas.upenn.edu>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 15, 2010 at 07:41:22PM -0400, Rafi Rubin wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> >> +	if (ts->tc.event_sended == false) {
> > 
> > We set "event_sended" to false immediately before calling
> > cy8ctmg110_send_event() so I do not see the point of this flag.
> 
> On that note:
> 
> $ git grep -n sended
> drivers/net/eth16i.c:1295:
> 		how many packets there is to be sended */
> drivers/net/wan/sbni.c:638:
> 		/* if frame was sended but not ACK'ed - resend it */
> drivers/net/wan/sbni.c:659:
> 		* frame sended then in prepare_to_send next frame
> drivers/usb/serial/aircable.c:13:
> 		* next two bytes must say how much data will be sended.
> 

Well, if you want to go down that path...

[dtor@hammer work]$ grep -r -e "\(setted\|setuped\|split\+ed\)" . | wc -l
54
[dtor@hammer work]$ 

-- 
Dmitry
