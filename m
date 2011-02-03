Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753922Ab1BCV4d (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Feb 2011 16:56:33 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:38663 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab1BCV4a convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Feb 2011 16:56:30 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=MmDCcouvxn2Oi/jo/GHo4dqbi9kWzt19+nRxa5KVAv0Fc+fbfCm0rLUf6ogL+26YOo
         6K9wXIUAy43XKH6ILZRZdY5ka1vn+fCLX9zkD7tqy5WVJywImzxh12H3oDGdHtGPaOcV
         ic0hbb1Adm9pTRSX8JdVdsVjBdtFLc20tdzUo=
MIME-Version: 1.0
In-Reply-To: <201102032009.17100.rjw@sisk.pl>
References: <e9vOd5LzdBK.A.dyD.h6eSNB@chimera>
	<AANLkTikELiGS+fM5WguZS=Fo-sSXmej1UnKWqCFmnE0k@mail.gmail.com>
	<s5haaid3xos.wl%tiwai@suse.de>
	<201102032009.17100.rjw@sisk.pl>
Date: Thu, 3 Feb 2011 22:56:29 +0100
Message-ID: <AANLkTi=suS1VDL=6EtT0D2=0c1DWwxdwZBBv=-BySNX-@mail.gmail.com>
Subject: Re: 2.6.38-rc3-git1: Reported regressions 2.6.36 -> 2.6.37
From: Carlos Mafra <crmafra2@gmail.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Keith Packard <keithp@keithp.com>, Dave Airlie <airlied@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux SCSI List <linux-scsi@vger.kernel.org>,
        Linux Wireless List <linux-wireless@vger.kernel.org>,
        DRI <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 3, 2011 at 8:09 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> On Thursday, February 03, 2011, Takashi Iwai wrote:
>> At Thu, 3 Feb 2011 07:42:05 -0800,
>> Linus Torvalds wrote:
>> >
>> > On Thu, Feb 3, 2011 at 3:23 AM, Carlos R. Mafra <crmafra2@gmail.com> wrote:
>> > > On Thu  3.Feb'11 at  1:03:41 +0100, Rafael J. Wysocki wrote:

>> > Just to confirm, can you also check -rc3? I'm pretty sure nothing has
>> > changed, but there were a few drm patches after -rc2, so it's alsways
>> > good to double-check.
>>
>> The problem I reported in the bugzilla above is still present in
>> 2.6.38-rc3.  I'm pretty sure that's the same issue as Carlos' case.
>
> I added https://bugzilla.kernel.org/show_bug.cgi?id=24982 to the list of
> post-2.6.36 regressions for further tracking.

I also tested on 2.6.38-rc3+ now and the issue is not solved,
just like Takashi expected.
