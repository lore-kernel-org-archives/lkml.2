Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755064Ab1AGBOy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 20:14:54 -0500
Received: from mail-iw0-f174.google.com ([209.85.214.174]:64552 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754961Ab1AGBOw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 20:14:52 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-type:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        b=UNgR1aTl5GmiQV3WswjfA4Fic3XYn/vBJ7zRLR72CjFFHvk/P60iYMiZlSwBZRm07z
         Jwgo3aBcRhsLhOltY/rxXIrReFGfsUhZc/OpgrjV+zFS63nm/plr1pNryHpnJboIxnN/
         Zd/MF4rZyrzldGYVZOCVAm9BjvZrsQZOv8Trw=
Date: Thu, 6 Jan 2011 17:14:44 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Jiri Kosina <jkosina@suse.cz>
Cc: Benjamin Tissoires <benjamin.tissoires@enac.fr>,
        Henrik Rydberg <rydberg@euromail.se>, Stephane Chatty <chatty@enac.fr>,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC v2 0/10] hid-multitouch: a first step towards multitouch
 unification
Message-ID: <20110107011444.GA7262@core.coreip.homeip.net>
References: <1294248468-19979-1-git-send-email-benjamin.tissoires@enac.fr>
 <20110105174927.GB2146@polaris.bitmath.org>
 <AANLkTikCqufvOgYqqBZLjfmtSdsgyQV4L2HyvEP07+vf@mail.gmail.com>
 <alpine.LNX.2.00.1101061610270.26685@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <alpine.LNX.2.00.1101061610270.26685@pobox.suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 06, 2011 at 04:11:46PM +0100, Jiri Kosina wrote:
> On Thu, 6 Jan 2011, Benjamin Tissoires wrote:
> 
> > Hi Henrik,
> > 
> > thanks for the future review ;)
> > 
> > Well, patches n° 3,4,5,6 and 7 are only those sent by Stéphane and
> > reviewed by you 3 months ago with small changes:
> >   - I took into account most of your comments
> >   - I inserted suspend/resume support
> >   - I implemented a way to find out the end of a mt report.
> > 
> > Patch 1 (hid: add feature_mapping callback) is new but not very
> > dangerous I think: it only adds a hook. Thanks to it, I could retrieve
> > the magic number which is device-specific.
> > 
> > Patch 2 (hid: set HID_MAX_FIELD at 128) may need further discussions
> > (but is required to use Stantum panels)
> > 
> > the last patches only introduce support for 3 devices, 1 of them is
> > new for the kernel.
> > 
> > The point is that currently we have users that want to have a proper
> > support for their device (PixCir, Cypress TrueTouch and GeneralTouch),
> > and it's a shame to ask them to wait for 3 more months.
> > 
> > Maybe a solution would be to make what we can here during this merge
> > window to add support for at least the new devices. Then, in 2.6.39
> > and above, we could still migrate other devices, and eventually modify
> > some lines in the code.
> > 
> > Jiri, Dmitry, what do you think?
> 
> I still have to go through the patchset, my backlog has grown very badly 
> recently, sorry.
> 
> In case the patchset doesn't impose danger of regressions for already 
> existing devices, we could merge this new 'unified' driver only for newly 
> supported devices, and finish the unification in 2.6.39.
> 

Yep, let's merge the dirver and all new devices in this round and then
get ready to convert already supported devices in next window.

-- 
Dmitry
