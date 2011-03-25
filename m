Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754473Ab1CYQIp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 12:08:45 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:34376 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754439Ab1CYQIn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 12:08:43 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=omzKbh8mOtL9XrRQagseV0bBWli5qHNCrrAOEhTb6THlC9u1PheYhKiBkiDkOMz7lO
         2yETDTfYIbMLFMbD0hFal1pakVqcuU1JvfZvisoagADJokYEd5hlN+fcj4zo1zEnOiCA
         9AyzCcb2+LT8nnEQ5gEr8qaGjPf06DT1ymqpQ=
MIME-Version: 1.0
In-Reply-To: <20110325160702.GB5099@core.coreip.homeip.net>
References: <1300909189-4135-1-git-send-email-seth.forshee@canonical.com>
	<AANLkTinZpt8qmHzhe4WyteMt-C-nkVNwEGQVvq3Nk9Lx@mail.gmail.com>
	<20110324131414.GA20612@thinkpad-t410>
	<AANLkTikrX_wypmrd-PbST603jsHqkuwtA6t5X65Lg1+O@mail.gmail.com>
	<AANLkTi=2OKxvHN75PO4RGb9rtpnA0iGHNb9JPZwb0z9J@mail.gmail.com>
	<AANLkTik7D0j=JOhzPk6Y2NrTA89-vS28wPDSS=j0VW4_@mail.gmail.com>
	<20110325160702.GB5099@core.coreip.homeip.net>
Date: Fri, 25 Mar 2011 16:08:41 +0000
Message-ID: <AANLkTinPAwWOONsD=DTM0go1_kb_DKaCeUk4dJ1Nvftz@mail.gmail.com>
Subject: Re: [PATCH] eeepc-wmi: Add support for T101MT "Express Gate" key
From: Corentin Chary <corentin.chary@gmail.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Chris Bagwell <chris@cnpbagwell.com>, Matthew Garrett <mjg@redhat.com>,
        acpi4asus-user@lists.sourceforge.net,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Seth Forshee <seth.forshee@canonical.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 25, 2011 at 4:07 PM, Dmitry Torokhov
<dmitry.torokhov@gmail.com> wrote:
> On Thu, Mar 24, 2011 at 09:00:14AM -0500, Chris Bagwell wrote:
>> On Thu, Mar 24, 2011 at 8:40 AM, Corentin Chary
>> <corentin.chary@gmail.com> wrote:
>> >> I would suggest sending BTN_HOME upon button release 0xe5 (not press
>> >> 0xe4 and do the autorelease because of it) and BTN_PROG2 on
>> >> press-and-hold 0xea.
>> >>
>> >> If you press-and-hold, does it still send the 0xe5 upon release?  That
>> >> could complicate things so that both button events do not get sent.
>> >>
>> >> I'm not sure what BTN_HOME is commonly used for.  This button does
>> >> sound like a HOME button in iPad sense but not in web browser sense.
>> >
>> > Except the fact that I don't find BTN_HOME in inpout.h, that's seems a
>> > better idea, forget what I've said earlier.
>>
>> Ha... Sorry, I had buttons on my brain.  I meant KEY_HOME as you suggested.
>>
>> >
>> > 0xe4 -> KEY_IGNORE
>> > 0xe5 -> KEY_HOME
>> > 0xea -> KEY_PROG2, (or BTN_TASK to copy android/iOS ?)
>>
>> From a quick google, I couldn't finding any specific meaning of
>> BTN_TASK but it looks like xf86-input-evdev turns it into a button
>> press so we may not want that one.
>>
>
> It was one of additional keys on Logitech mice IIRC.

I thinks it's the same as KEY_CYCLEWINDOWS (there are little windows
on the button).

-- 
Corentin Chary
http://xf.iksaif.net
