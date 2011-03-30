Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755345Ab1C3SaM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Mar 2011 14:30:12 -0400
Received: from incomingmail.riverbed.com ([208.70.196.45]:5914 "EHLO
	smtp1.riverbed.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab1C3SaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Mar 2011 14:30:10 -0400
From: "Francis St. Amant" <Francis.St.Amant@riverbed.com>
To: Borislav Petkov <bp@amd64.org>, "Luck, Tony" <tony.luck@intel.com>
CC: Mauro Carvalho Chehab <mchehab@redhat.com>, Borislav Petkov <bp@alien8.de>,
        Linux Edac Mailing List <linux-edac@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Date: Wed, 30 Mar 2011 11:30:00 -0700
Subject: RE: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Thread-Topic: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly
 Report Mechanism (HARM)
Thread-Index: AcvvAxLLctO5rafAS7mIheC7u/G/uwABMkZg
Message-ID: <05E7F0869FB1C54AA467D77BC9C9E63F3FF7EEC271@MAILBOXES.nbttech.com>
References: <cover.1300996141.git.mchehab@redhat.com>
 <20110324173257.36680b90@pedra> <20110324223907.GA10498@liondog.tnic>
 <4D8C6C80.8010600@redhat.com> <20110325141322.GB28313@gere.osrc.amd.com>
 <4D8D078C.1040201@redhat.com> <20110328170302.GF11590@aftab>
 <4D90E525.4030709@redhat.com>
 <987664A83D2D224EAE907B061CE93D5301A7A60074@orsmsx505.amr.corp.intel.com>
 <20110330175106.GB1601@aftab>
In-Reply-To: <20110330175106.GB1601@aftab>
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
X-MIME-Autoconverted: from base64 to 8bit by mail.home.local id p2UIUKSH021455

Hi,

Sorry for using your BW but I wonder if you can do me a favor and remove Arthur Jones (Arthur.jones@riverbed.com; ajones@riverbed.com) from this list?  I tried to do that via the unsubscribe method at bottom but it didn't work.

Arthur has left Riverbed, and as his former manager I now get all his emails forwarded to me.  Since I'm not useful to this list, there's no reason to receive all these emails.  Probably my attempt to unsubscribe didn't work because the email came from me and I'm already not on the list--Arthur is.

Thanks very much,

- - - - - - - - - - - - - - - - - - - - - - - - - -
Francis St. Amant
Sr. Mgr., Platform/OEM Engineering
Riverbed Technology
francis@riverbed.com
Voice: 415-344-4480
FAX: 415-247-8801


-----Original Message-----
From: linux-edac-owner@vger.kernel.org [mailto:linux-edac-owner@vger.kernel.org] On Behalf Of Borislav Petkov
Sent: Wednesday, March 30, 2011 10:51 AM
To: Luck, Tony
Cc: Mauro Carvalho Chehab; Borislav Petkov; Borislav Petkov; Linux Edac Mailing List; Linux Kernel Mailing List
Subject: Re: [PATCH RFC 2/2] events/hw_event: Create a Hardware Anomaly Report Mechanism (HARM)

On Wed, Mar 30, 2011 at 01:27:43PM -0400, Luck, Tony wrote:
> > A INT13 persistent data saving will probably be too hard to implement for
> > all kind of storages. So, it will probably need lots of hack in order to
> > work. Also, some hardware may even not have any local hard disk. Not sure
> > if it is worth to spend time on it.
> 
> Linus was pretty clear that he didn't like the idea when
> it came up a few weeks ago in the:
>  [PATCH 0/2][conceâ€‹pt RFC] x86: BIOS-save kernel log to disk upon panic
> thread.
> 
> Linus ranted:
> > Quite frankly, I'm not likely to _ever_ merge anything like this.
> >
> > Over the years, many people have tried to write things to disk on
> > oops. I refuse to take it. No way in hell do I want the situation of
> > "the system is screwed, so let's overwrite the disk" to be something
> > the kernel I release might do. It's crazy. That disk is a lot more
> > important than the kernel, and overwriting it when we might have
> > serious memory corruption issues or something is not a thing I feel is
> > appropriate.
> 
> I agree with him - writing to disk from a known broken kernel (using
> a probably buggy BIOS) is a disaster waiting to happen to somebody's
> disk.

I can't say I don't agree. The reference to the BIOS method was simply
to say that we need some kind of a solution for saving OOPSen and other
error info on clients too, with no pers. storage hw. And frankly, and
AFAICT, we don't have one that would work reliably on existing hw right
now :(.

-- 
Regards/Gruss,
Boris.

Advanced Micro Devices GmbH
Einsteinring 24, 85609 Dornach
General Managers: Alberto Bozzo, Andrew Bowd
Registration: Dornach, Gemeinde Aschheim, Landkreis Muenchen
Registergericht Muenchen, HRB Nr. 43632
--
To unsubscribe from this list: send the line "unsubscribe linux-edac" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
ÿôèº{.nÇ+‰·Ÿ®‰­†+%ŠËÿ±éİ¶¥Šwÿº{.nÇ+‰·¥Š{±şG«éÿŠ{ayºÊ‡Ú™ë,j­¢f£¢·hšïêÿ‘êçz_è®(­éšŠİ¢j"ú¶m§ÿÿ¾«şG«éÿ¢¸?™¨è­Ú&£ø§~á¶iO•æ¬z·švØ^¶m§ÿÿÃÿ¶ìÿ¢¸?–I¥
