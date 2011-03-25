Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754315Ab1CYQHJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:07:09 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:33933 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753973Ab1CYQHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:07:07 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=uG8uP1Vw62jaJP3cLpQxqWb9e/WOAlLGAN7r4Z1HVwaPO+3wa4OT3d5PMiQwEKd2BS
         3flFCKV6ZeDuFPEEm+T8Hg+oAAMHzMeUqxMUnMHOBdci1QTdOdZSbfPclz0Xjb3KwxGC
         viflMu2b7VrpZaus8P6M4IJ4zLcIopAb7NczI=
Date: Fri, 25 Mar 2011 09:07:02 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Chris Bagwell <chris@cnpbagwell.com>
Cc: Corentin Chary <corentin.chary@gmail.com>,
        Matthew Garrett <mjg@redhat.com>, acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Subject: Re: [PATCH] eeepc-wmi: Add support for T101MT "Express Gate" key
Message-ID: <20110325160702.GB5099@core.coreip.homeip.net>
References: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
 <AANLkTinZpt8qmHzhe4WyteMt-C-nkVNwEGQVvq3Nk9Lx@mail.gmail.com>
 <20110324131414.GA20612@thinkpad-t410>
 <AANLkTikrX_wypmrd-PbST603jsHqkuwtA6t5X65Lg1+O@mail.gmail.com>
 <AANLkTi=2OKxvHN75PO4RGb9rtpnA0iGHNb9JPZwb0z9J@mail.gmail.com>
 <AANLkTik7D0j=JOhzPk6Y2NrTA89-vS28wPDSS=j0VW4_@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <AANLkTik7D0j=JOhzPk6Y2NrTA89-vS28wPDSS=j0VW4_@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 24, 2011 at 09:00:14AM -0500, Chris Bagwell wrote:
> On Thu, Mar 24, 2011 at 8:40 AM, Corentin Chary
> <corentin.chary@gmail.com> wrote:
> >> I would suggest sending BTN_HOME upon button release 0xe5 (not press
> >> 0xe4 and do the autorelease because of it) and BTN_PROG2 on
> >> press-and-hold 0xea.
> >>
> >> If you press-and-hold, does it still send the 0xe5 upon release?  That
> >> could complicate things so that both button events do not get sent.
> >>
> >> I'm not sure what BTN_HOME is commonly used for.  This button does
> >> sound like a HOME button in iPad sense but not in web browser sense.
> >
> > Except the fact that I don't find BTN_HOME in inpout.h, that's seems a
> > better idea, forget what I've said earlier.
> 
> Ha... Sorry, I had buttons on my brain.  I meant KEY_HOME as you suggested.
> 
> >
> > 0xe4 -> KEY_IGNORE
> > 0xe5 -> KEY_HOME
> > 0xea -> KEY_PROG2, (or BTN_TASK to copy android/iOS ?)
> 
> From a quick google, I couldn't finding any specific meaning of
> BTN_TASK but it looks like xf86-input-evdev turns it into a button
> press so we may not want that one.
> 

It was one of additional keys on Logitech mice IIRC.

-- 
Dmitry
