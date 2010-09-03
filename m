Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755413Ab0ICQ0U (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Sep 2010 12:26:20 -0400
Received: from mail-qy0-f174.google.com ([209.85.216.174]:60106 "EHLO
	mail-qy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab0ICQ0T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Sep 2010 12:26:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=CzLhoC/gnSBbJPfGRxJGsqOgBgbZV0vydEyDL/EOJFByzirMck5c5dGdzCNVJ51Rf6
         0SVIkNoPwGIXOzUxzZY09xbKtsBa93W7/LS2eveQiHsFqtfQsXUaJgym34zVDCdPLK0s
         tJ28XnDjdoF2/IZpxKcE+0FMuEmA9XdLWnwQw=
Date: Fri, 3 Sep 2010 09:26:08 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Ping Cheng <pinglinux@gmail.com>
Cc: Henrik Rydberg <rydberg@euromail.se>, Ping Cheng <pingc@wacom.com>,
        Chris Bagwell <chris@cnpbagwell.com>, linux-input@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] input: wacom: Add support for the Bamboo Touch
 trackpad (rev3)
Message-ID: <20100903162608.GA2200@core.coreip.homeip.net>
References: <1283516247-11624-1-git-send-email-rydberg@euromail.se>
 <1283516247-11624-4-git-send-email-rydberg@euromail.se>
 <6753EB6004AFF34FAA275742C104F952022BB10E@wacom-nt10.wacom.com>
 <4C80F2CD.2040708@euromail.se>
 <AANLkTinUxPMezfSHjfPPJ6PoZ1Put26ZAMrzQ36K2fjV@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTinUxPMezfSHjfPPJ6PoZ1Put26ZAMrzQ36K2fjV@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-12-10)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 03, 2010 at 05:30:27PM +0200, Ping Cheng wrote:
> On Fri, Sep 3, 2010 at 3:06 PM, Henrik Rydberg <rydberg@euromail.se> wrote:
> > On 09/03/2010 03:01 PM, Ping Cheng wrote:
> > [...]
> >
> >> +     input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
> >> +     input_report_key(input, BTN_MIDDLE, (data[1] & 0x04) != 0);
> >> +     input_report_key(input, BTN_4, (data[1] & 0x02) != 0);
> >> +     input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
> >>
> >> Since you are assigning meaningful defaults to three of the tablet
> >> buttons instead of using BTN_#, can we move one more step to make the
> >> fourth button useful out-of-box too? I am thinking of something like
> >> BTN_FORWARD and BTN_BACK while getting rid of the BTN_MIDDLE. So, it
> >> would be:
> >>
> >>       input_report_key(input, BTN_LEFT, (data[1] & 0x08) != 0);
> >>       input_report_key(input, BTN_FORWARD, (data[1] & 0x04) != 0);
> >>       input_report_key(input, BTN_BACK, (data[1] & 0x02) != 0);
> >>       input_report_key(input, BTN_RIGHT, (data[1] & 0x01) != 0);
> >>
> >> Does this make sense to you?
> >
> >
> > Well, this is all a matter of taste, isn't it. If middle-button emulation works
> > out of the box, for the benefit of us old X users who seem unwilling to ever let
> > go of the click-to-paste functionality, then I would not mind terribly.
> 
> I agree and I use middle click more than right click myself ;). I just
> wanted to give BTN_4 a life. If no one has a good suggestion for that,
> I can live with it.
> 

Another option could be allowing usirs to remap buttons via EVIOGSKEYCODE.

-- 
Dmitry
