Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758603Ab0IHJrk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Sep 2010 05:47:40 -0400
Received: from cantor.suse.de ([195.135.220.2]:56142 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752837Ab0IHJrh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Sep 2010 05:47:37 -0400
Date: Wed, 8 Sep 2010 11:47:35 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Jiri Slaby <jirislaby@gmail.com>
Cc: Rafi Rubin <rafi@seas.upenn.edu>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        micki@n-trig.com, rydberg@euromail.se, chatty@enac.fr
Subject: Re: [PATCH] identify firmware version
In-Reply-To: <4C85E1A7.2010906@gmail.com>
Message-ID: <alpine.LNX.2.00.1009081147070.26813@pobox.suse.cz>
References: <4C7EB3A3.7050402@gmail.com> <1283791362-27780-1-git-send-email-rafi@seas.upenn.edu> <20100906194838.GB31384@core.coreip.homeip.net> <4C855BAA.4000900@gmail.com> <20100906233203.GA18048@seas.upenn.edu> <4C85E1A7.2010906@gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 7 Sep 2010, Jiri Slaby wrote:

> >>>> +
> >>>> +		ret = ntrig_version_string(&data[2], buf);
> >>>> +
> >>>> +		dev_info(&hdev->dev,
> >>>> +			 "Firmware version: %s (%02x%02x %02x%02x)\n",
> >>>> +			 buf, data[2], data[3], data[4], data[5]);
> >>>> +
> >>>> +		kfree(buff);
> >>
> >> In any case, this doesn't compile...
> >>
> >>>> +	}
> > 
> > Jiri, I moved the code to a separate function as Dmitry suggested, and compiled a kernel from a clean tree using 
> > gcc-3.4 (I think).
> 
> This version is OK. In the previous one, there was
> char *buf;
> ...
> kfree(buff);

Dmitry, Jiri, thanks a lot for taking care reviewing the patch while I 
have been lagging behind.

Now applied, thanks Rafi.

-- 
Jiri Kosina
SUSE Labs, Novell Inc.
