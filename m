Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754112Ab1INIj2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Sep 2011 04:39:28 -0400
Received: from mail-ww0-f44.google.com ([74.125.82.44]:57161 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752998Ab1INIj0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Sep 2011 04:39:26 -0400
Date: Wed, 14 Sep 2011 16:39:17 +0800
From: Yong Zhang <yong.zhang0@gmail.com>
To: "Nallasellan, Singaravelan" <singaravelan.nallasellan@intel.com>
Cc: Arjan van de Ven <arjan@infradead.org>,
        "alsa-devel@alsa-project.org" <alsa-devel@alsa-project.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: Player Thread is not woken after period elapsed
Message-ID: <20110914083916.GA23710@zhy>
Reply-To: Yong Zhang <yong.zhang0@gmail.com>
References: <3CA6C6D9F70D314CA34352990B57DA1507C420F15C@bgsmsx502.gar.corp.intel.com>
 <20110905112225.72b46ac9@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C4275D58@bgsmsx502.gar.corp.intel.com>
 <20110906200614.57a99d3d@infradead.org>
 <3CA6C6D9F70D314CA34352990B57DA1507C42767FA@bgsmsx502.gar.corp.intel.com>
 <20110908021327.GA8890@zhy>
 <20110908072948.GB11124@zhy>
 <3CA6C6D9F70D314CA34352990B57DA1507C42C3CA5@bgsmsx502.gar.corp.intel.com>
 <20110909060725.GA21124@zhy>
 <3CA6C6D9F70D314CA34352990B57DA1507C4317651@bgsmsx502.gar.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <3CA6C6D9F70D314CA34352990B57DA1507C4317651@bgsmsx502.gar.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 09, 2011 at 06:12:03PM +0530, Nallasellan, Singaravelan wrote:
> > > > > > Further investigation of this issue shows that the thread is in
> > > > > > running state
> > 
> > Hmm, how do you detect it?
> > 
> > > > and it is not scheduled. I am not sure how I will go about debugging this
> > issue.
> > > > Any pointer would help.
> > 
> > Could 'cat /proc/sched_debug' give some useful info?
> Tried. It did not help.
> > 
> > And BTW, have you tried CONFIG_DETECT_SOFTLOCKUP = y?
> > 
> It is already set. 

That sound at least kwatchdogd could be scheduled suscessfully.

And if CONFIG_DETECT_HUNG_TASK could not bite your "Player Thread",
I have no idea what's going on.

Maybe you could try the latest kernel?

Thanks,
Yong
