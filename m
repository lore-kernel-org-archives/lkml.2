Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185Ab1C3UBC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 16:01:02 -0400
Received: from smtp.riverbed.com ([208.70.196.44]:50337 "EHLO
	smtp2.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754979Ab1C3UA7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 16:00:59 -0400
From: "Francis St. Amant" <Francis.St.Amant@riverbed.com>
To: Borislav Petkov <bp@amd64.org>, David Miller <davem@davemloft.net>
CC: "Luck, Tony" <tony.luck@intel.com>,
        Mauro Carvalho Chehab <mchehab@redhat.com>,
        Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 30 Mar 2011 13:00:46 -0700
Subject: RE: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Thread-Topic: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Thread-Index: AcvvE76fkGPy1A4nQzqoqvgIdAVL3QAAKUzQ
Message-ID: <05E7F0869FB1C54AA467D77BC9C9E63F3FF7EEC289@MAILBOXES.nbttech.com>
References: <20110324173257.36680b90@pedra>
 <20110324223907.GA10498@liondog.tnic> <4D8C6C80.8010600@redhat.com>
 <20110325141322.GB28313@gere.osrc.amd.com> <4D8D078C.1040201@redhat.com>
 <20110328170302.GF11590@aftab> <4D90E525.4030709@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301A7A60074@orsmsx505.amr.corp.intel.com>
 <20110330175106.GB1601@aftab>
 <05E7F0869FB1C54AA467D77BC9C9E63F3FF7EEC271@MAILBOXES.nbttech.com>
 <20110330195025.GA4297@aftab>
In-Reply-To: <20110330195025.GA4297@aftab>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
acceptlanguage: en-US
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2UK17B0021908

If it's not easy from your side, I can go to our IT and ask if they can revive Arthur's account just to send this one unsubscribe :) 

FWIW on the below email, I do agree that some way to save OOPS output is very useful.  In our case Arthur created a special serial driver which wrote to EEPROM instead of console--besides not endangering the disk, a lot less SW has to be executed to save the data.  Then we fetch it back on next boot.

Thanks again,

  - Francis
 

-----Original Message-----
From: Borislav Petkov [mailto:bp@amd64.org] 
Sent: Wednesday, March 30, 2011 12:50 PM
To: Francis St. Amant; David Miller
Cc: Borislav Petkov; Luck, Tony; Mauro Carvalho Chehab; Borislav Petkov; Linux Edac Mailing List; Linux Kernel Mailing List
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly Report Mechanism (HARM)

Right,

I guess you have to send from the subscribed mail address. Well, I don't
know how to unsubscribe in that case either, but maybe David can help
us.

David, can you please take a look?

Thanks.

On Wed, Mar 30, 2011 at 02:30:00PM -0400, Francis St. Amant wrote:
> Hi,
> 
> Sorry for using your BW but I wonder if you can do me a favor and remove Arthur Jones (Arthur.jones@riverbed.com; ajones@riverbed.com) from this list?  I tried to do that via the unsubscribe method at bottom but it didn't work.
> 
> Arthur has left Riverbed, and as his former manager I now get all his emails forwarded to me.  Since I'm not useful to this list, there's no reason to receive all these emails.  Probably my attempt to unsubscribe didn't work because the email came from me and I'm already not on the list--Arthur is.
> 
> Thanks very much,
> 
> - - - - - - - - - - - - - - - - - - - - - - - - - -
> Francis St. Amant
> Sr. Mgr., Platform/OEM Engineering
> Riverbed Technology
> francis@riverbed.com
> Voice: 415-344-4480
> FAX: 415-247-8801
> 
> 
> -----Original Message-----
> From: linux-edac-owner@vger.kernel.org [mailto:linux-edac-owner@vger.kernel.org] On Behalf Of Borislav Petkov
> Sent: Wednesday, March 30, 2011 10:51 AM
> To: Luck, Tony
> Cc: Mauro Carvalho Chehab; Borislav Petkov; Borislav Petkov; Linux Edac Mailing List; Linux Kernel Mailing List
> Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly Report Mechanism (HARM)
> 
> On Wed, Mar 30, 2011 at 01:27:43PM -0400, Luck, Tony wrote:
> > > A INT13 persistent data saving will probably be too hard to implement for
> > > all kind of storages. So, it will probably need lots of hack in order to
> > > work. Also, some hardware may even not have any local hard disk. Not sure
> > > if it is worth to spend time on it.
> > 
> > Linus was pretty clear that he didn't like the idea when
> > it came up a few weeks ago in the:
> >  [PATCH 0/2][conceâ€‹pt RFC] x86: BIOS-save kernel log to disk upon panic
> > thread.
> > 
> > Linus ranted:
> > > Quite frankly, I'm not likely to _ever_ merge anything like this.
> > >
> > > Over the years, many people have tried to write things to disk on
> > > oops. I refuse to take it. No way in hell do I want the situation of
> > > "the system is screwed, so let's overwrite the disk" to be something
> > > the kernel I release might do. It's crazy. That disk is a lot more
> > > important than the kernel, and overwriting it when we might have
> > > serious memory corruption issues or something is not a thing I feel is
> > > appropriate.
> > 
> > I agree with him - writing to disk from a known broken kernel (using
> > a probably buggy BIOS) is a disaster waiting to happen to somebody's
> > disk.
> 
> I can't say I don't agree. The reference to the BIOS method was simply
> to say that we need some kind of a solution for saving OOPSen and other
> error info on clients too, with no pers. storage hw. And frankly, and
> AFAICT, we don't have one that would work reliably on existing hw right
> now :(.
> 
> -- 
> Regards/Gruss,
> Boris.
> 
> Advanced Micro Devices GmbH
> Einsteinring 24, 85609 Dornach
> General Managers: Alberto Bozzo, Andrew Bowd
> Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
> Registergericht Muenchen, HRB Nr. 43632
> --
> To unsubscribe from this list: send the line "unsubscribe linux-edac" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
