Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757014Ab0JYRHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Oct 2010 13:07:43 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:36654 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752764Ab0JYRHj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Oct 2010 13:07:39 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type;
        b=UzQGCbAXoWyDbVQtzV+OA9QHwVRe/cU1i3KNPsLMtw3L6H3DS+0oDw7veCEp5kZGf2
         GKLfZh/JwItxl667cfkFv4b6BsatDe1B2/yFb0PVl9EfZDtr5JeFlm58yCEDoNnRrMys
         v2hVp+PpW/pjaTMqfG4C7YrfJVGrQPt5MRch8=
MIME-Version: 1.0
In-Reply-To: <4CC5726B.1020207@redhat.com>
References: <1287992610-14996-1-git-send-email-ying.huang@intel.com>
	<1287992610-14996-10-git-send-email-ying.huang@intel.com>
	<20101025084553.GA27119@elte.hu>
	<1287997112.2862.322.camel@yhuang-dev>
	<20101025091913.GA17622@basil.fritz.box>
	<20101025111530.GA27659@elte.hu>
	<4CC5726B.1020207@redhat.com>
Date: Mon, 25 Oct 2010 10:07:36 -0700
Message-ID: <AANLkTin=WM5AN_z_SxaKgOta-Q0xQnyO2S-G5w7JOQSh@mail.gmail.com>
Subject: Re: [NAK] Re: [PATCH -v2 9/9] ACPI, APEI, Generic Hardware Error
 Source POLL/IRQ/NMI notification type support
From: Tony Luck <tony.luck@gmail.com>
To: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: Ingo Molnar <mingo@elte.hu>, Andi Kleen <andi@firstfloor.org>,
        Huang Ying <ying.huang@intel.com>, Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        Borislav Petkov <petkovbb@googlemail.com>,
        Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        Don Zickus <dzickus@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arjan van de Ven <arjan@infradead.org>, Borislav Petkov <bp@amd64.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 25, 2010 at 5:04 AM, Mauro Carvalho Chehab
<mchehab@redhat.com> wrote:
> We had some discussions with Intel during the Collaboration summit about that, trying to
> integrate Nehalem EX on such environment, with, unfortunately, didn't happen, as Intel
> didn't release any (public) datasheet describing Nehalem EX memory controller, nor wrote
> such driver.

The chipset registers that are needed to write an EDAC driver for
Nehalem-EX (a.k.a Xeon
7500 series) are not accessible to OS (ring 0) code. Documenting them
wouldn't change this.

> As most of us will be in Boston next week, I've reserved a BoF at Plumbers for us to discuss
> about this subject:
>
> http://www.linuxplumbersconf.org/2010/ocw/proposals/921

An excellent idea. See you there.

-Tony
