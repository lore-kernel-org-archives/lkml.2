Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752878Ab1I0UOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Sep 2011 16:14:06 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45112 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752331Ab1I0UOF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Sep 2011 16:14:05 -0400
Date: Tue, 27 Sep 2011 22:13:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: "Lucas C. Villa Real" <lucasvr@gobolinux.org>, Greg KH <gregkh@suse.de>
Cc: linux-kernel@vger.kernel.org, Wey-Yi Guya <wey-yi.w.guy@intel.com>,
        Johannes Berg <johannes.berg@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] Initialize pointer on request_firmware
Message-ID: <20110927201358.GB4249@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	"Lucas C. Villa Real" <lucasvr@gobolinux.org>,
	Greg KH <gregkh@suse.de>, linux-kernel@vger.kernel.org,
	Wey-Yi Guya <wey-yi.w.guy@intel.com>,
	Johannes Berg <johannes.berg@intel.com>,
	Dmitry Torokhov <dmitry.torokhov@gmail.com>,
	Pekka Enberg <penberg@kernel.org>
References: <20110921235515.7476c5fe.lucasvr@gmail.com>
 <20110922092347.GD17640@liondog.tnic>
 <20110922171829.GA4863@suse.de>
 <20110922175406.GA4709@gere.osrc.amd.com>
 <20110922180327.GA1932@suse.de>
 <20110922182048.GB4709@gere.osrc.amd.com>
 <CAAvzgtZ3aWjpN++3qo1LCS9A+GsNzbnG0vEDqyDG8OHYJeXwuA@mail.gmail.com>
 <CAAvzgtZf2pFcKmAvccH4oJuiUJaugWbX1gwng7CK9B2DwN3ocA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAAvzgtZf2pFcKmAvccH4oJuiUJaugWbX1gwng7CK9B2DwN3ocA@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 23, 2011 at 12:51:36PM -0300, Lucas C. Villa Real wrote:
> On Thu, Sep 22, 2011 at 4:05 PM, Lucas C. Villa Real
> <lucasvr@gobolinux.org> wrote:
> > On Thu, Sep 22, 2011 at 3:20 PM, Borislav Petkov <bp@alien8.de> wrote:
> >> On Thu, Sep 22, 2011 at 11:03:27AM -0700, Greg KH wrote:
> >>> The patch was in the 2.6.36 kernel, so by nature of that, 3.0 will also
> >>> have it, right?
> >>
> >> Ok, a colleague of mine gave me 3.0.4 to stare at - and you're right
> >> the patch is there. So what is still missing is caca9510ff4e5 from
> >> upstream which reroutes the exit path so that firmware_p is NULLed
> >> before returning -EBUSY.
> >>
> >> Lucas, can you apply caca9510ff4e5 from upstream and verify it fixes the
> >> issue for ya?
> >
> > Sure. I'll do that tonight and will let you now -- the laptop I'm
> > using right now doesn't suffer from that problem.
> 
> caca9510ff4e5 fixes it. Thanks for the pointer!

Looks like the ball is with Greg now :-).

Thanks.

-- 
Regards/Gruss,
    Boris.
