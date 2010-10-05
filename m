Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755636Ab0JEQSe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Oct 2010 12:18:34 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:59117 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752274Ab0JEQSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Oct 2010 12:18:33 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:in-reply-to:user-agent;
        b=w1lRscKv/fLEY2CYv2wecsDlHwrzJBDKiEvtMU0ypOgdDPxToBxuRDbR72iDEEUigV
         UJHlIdUExRSR5Y8rvMpBaRkPetXGIRXbHoNesK7GiTSlaRB1pnhXDyIOWl3ANzzp7pWC
         patkitTVOsHWmfrppkGClrR6RZXthb79gndWE=
Date: Tue, 5 Oct 2010 09:18:26 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Oliver Neukum <oliver@neukum.org>
Cc: Bastien Nocera <hadess@hadess.net>,
        linux-input <linux-input@vger.kernel.org>,
        Jiri Kosina <jkosina@suse.cz>,
        linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: [RESEND] [PATCH] Input: add appleir USB driver
Message-ID: <20101005161826.GE19730@core.coreip.homeip.net>
References: <1285844276.26405.26.camel@cookie.hadess.net>
 <201010050818.35118.oliver@neukum.org>
 <20101005155552.GB19730@core.coreip.homeip.net>
 <201010051807.36551.oliver@neukum.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201010051807.36551.oliver@neukum.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 05, 2010 at 06:07:36PM +0200, Oliver Neukum wrote:
> Am Dienstag, 5. Oktober 2010, 17:55:52 schrieb Dmitry Torokhov:
> > > Yes, but based on sane timing. From the time stamps user space
> > > would conclude that the key had been pressed at an unknown time
> > > before open and released at the time the event indicates. Possibly
> > > it would compute that the key had been held for at least hours.
> > > 
> > 
> > I do not understand. If a client never seen the "press" event and only
> > saw "release" event it can't make any assumptions about timing. Press
> > could be a millisecond ago or an hour ago, it just does not know. And
> > such scenario can easily happen if the client is second to open the
> > device.
> 
> As soon as you open a device you see key presses. If you see a release
> without a press, the press must have happened before you opened.
> So if you know when you opened and when a key is released, you'll
> have a lower limit on how long the key must have been held down.
> 

Yes. I still do not see the usefulness of this data.

-- 
Dmitry
