Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757094Ab1ILO0y (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Sep 2011 10:26:54 -0400
Received: from out4.smtp.messagingengine.com ([66.111.4.28]:33935 "EHLO
	out4.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756928Ab1ILO0x (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Sep 2011 10:26:53 -0400
X-Sasl-enc: fzsPF4D5DqU4+iDv0Y6yXnUXywomtE9GnXKXrtX9R5C5 1315837612
Date: Mon, 12 Sep 2011 16:26:41 +0200
From: Greg KH <greg@kroah.com>
To: Krzysztof Kanas <k.kanas@kelvatek.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Kernel  2.6.27.15  oops in PPP
Message-ID: <20110912142641.GA17687@kroah.com>
References: <4E6DCD36.6020104@kelvatek.com>
 <20110912113641.GA32603@kroah.com>
 <4E6DF7EC.8000206@kelvatek.com>
 <20110912124917.GA16428@kroah.com>
 <4E6E1446.8000009@kelvatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4E6E1446.8000009@kelvatek.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 12, 2011 at 04:16:38PM +0200, Krzysztof Kanas wrote:
> On 09/12/2011 02:49 PM, Greg KH wrote:
> >On Mon, Sep 12, 2011 at 02:15:40PM +0200, Krzysztof Kanas wrote:
> >>On 09/12/2011 01:36 PM, Greg KH wrote:
> >>>On Mon, Sep 12, 2011 at 11:13:26AM +0200, Krzysztof Kanas wrote:
> >>>>Hi I am tracing kernel oops in 2.6.27.15 on ARM(CONFIG_CPU_ARM926T=y).
> >>>
> >>>2.6.27.15 is quite old, why that version?  If you are stuck on 2.6.27,
> >>>please use a newer stable version of it as odds are this is already
> >>>resolved in one of the 40+ releases after yours (current one is
> >>>2.6.27.57 I think.)
> >>>
> >>>thanks,
> >>>
> >>>greg k-h
> >>>
> >>Yes I am quite stuck with that version - I will try to get new
> >>stable version and see If that goes well. Unfortunately I have to
> >>make sure that all applications etc are still working with new
> >>kernel.
> >
> >There should not be _ANY_ user application change for stable kernel
> >updates like you would be doing from 2.6.27.15 to 2.6.27.57 as we only
> >accept bug fixes for stable kernel updates.
> >
> >greg k-h
> >
> 
> Thanks, unfortunately kernel.org is down,
> do you know by chance any other git mirror that I could use to clone
> 2.6.27.* repository so I could get patches from upstream ?

Look at one of the hundreds of kernel.org mirrors around the world to
get the patch files.  It's not the git tree though, sorry, I don't know
of any public mirrors of that at the moment.

greg k-h
