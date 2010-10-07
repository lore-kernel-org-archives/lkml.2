Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab0JGVuG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Oct 2010 17:50:06 -0400
Received: from mail-bw0-f46.google.com ([209.85.214.46]:58863 "EHLO
	mail-bw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753883Ab0JGVuE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Oct 2010 17:50:04 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:sender:in-reply-to:references:date
         :x-google-sender-auth:message-id:subject:from:to:cc:content-type;
        b=Cj4UlW/k6OUWb7e1q0J0IEjkwfHpBgd2jA8QtN4P8CVdaQTQWcCoI9AjEyj+7HB1f2
         he0QWW6tf3a3Gnw4dBgVAQ/5E4JP3tPjKOuVHy1AHbngXwgzRSq53RMnrEQsPJwFG5fn
         IgTP1c99nQ2lVvw4CDMrr1YEvzfVuw+FrCLDs=
MIME-Version: 1.0
In-Reply-To: <20101007214628.GB18628@core.coreip.homeip.net>
References: <1286422207-14248-1-git-send-email-keng-yu.lin@canonical.com>
	<20101007111510.GA19624@srcf.ucam.org>
	<AANLkTinus8SxbXt14qabXgpbFXF4U+uNoKA-=eDuOjmp@mail.gmail.com>
	<20101007133529.GA21782@srcf.ucam.org>
	<AANLkTi=kTQpTkCF6-DE+LdNLH_aki9bD9NPF0L2qRr=Q@mail.gmail.com>
	<20101007205049.GB32726@srcf.ucam.org>
	<AANLkTi=bj3T5hcX9r3j5kyEQkNb7PAZK948kcrx4R8tC@mail.gmail.com>
	<20101007213027.GA18628@core.coreip.homeip.net>
	<20101007213754.GA1896@srcf.ucam.org>
	<20101007214628.GB18628@core.coreip.homeip.net>
Date: Thu, 7 Oct 2010 16:49:50 -0500
X-Google-Sender-Auth: 4MYhSoC7NNGZyqq5dAZi0sAfIwM
Message-ID: <AANLkTikNdfNBf0pT6YxA5tHF2pjdWXPP0uXKNOq81hn2@mail.gmail.com>
Subject: Re: [PATCH] dell-laptop: Add hwswitch_only module parameter
From: Mario Limonciello <superm1@ubuntu.com>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Matthew Garrett <mjg59@srcf.ucam.org>,
        Keng-Yu Lin <keng-yu.lin@canonical.com>, len.brown@intel.com,
        alan-jenkins@tuffmail.co.uk, platform-driver-x86@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry:

On Thu, Oct 7, 2010 at 16:46, Dmitry Torokhov <dmitry.torokhov@gmail.com> wrote:
> On Thu, Oct 07, 2010 at 10:37:54PM +0100, Matthew Garrett wrote:
>> On Thu, Oct 07, 2010 at 02:30:28PM -0700, Dmitry Torokhov wrote:
>>
>> > We have this strategy for bunch of input stuff (force release, keymap)
>> > and I think it works better than dding more and more DMI quirks into
>> > kernel itself.
>>
>> It's limited to Dell hardware, so I think keeping a static list in the
>> Dell laptop driver is reasonable. All we need is a list of hardware, and
>> I'd really hope that Dell know which BIOS versions contain this code!
>>
>
> Unfortunately this kind of crap tends to flow from one BIOS version to
> another.. How many DMI entries do we know about so far? Did Dell issue
> firmware updates correcting the issue so new boxes will not exhibit the
> problem?
>
> --
> Dmitry
>

I've seen this on 2 machines thus far.  One of them is still under
development and this was caught in time to be fixed properly in the
firmware (thanks to the patch above).  The other will not be receiving
a firmware update to resolve it.

There are likely others out there, but I've not encountered them yet.

-- 
Mario Limonciello
superm1@gmail.com
