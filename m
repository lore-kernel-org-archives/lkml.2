Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756527Ab2JZGUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Oct 2012 02:20:43 -0400
Received: from mail-1.atlantis.sk ([80.94.52.57]:41456 "EHLO mail.atlantis.sk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756506Ab2JZGUl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Oct 2012 02:20:41 -0400
From: Ondrej Zary <linux@rainbow-software.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH] Enable A20 using KBC for some MSI laptops to fix S3 resume
Date: Fri, 26 Oct 2012 08:20:03 +0200
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Robert Hancock <hancockrwd@gmail.com>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <201210240847.52417.linux@rainbow-software.org> <508A122F.3090304@gmail.com> <e3c7bcc1-5562-4fb9-ab34-a8f1b391c34d@email.android.com>
In-Reply-To: <e3c7bcc1-5562-4fb9-ab34-a8f1b391c34d@email.android.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201210260820.03379.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 26 October 2012, H. Peter Anvin wrote:
> My guess is that Windows explicitly enables A20 on resume.  We should do
> that too, really... with the current heavily unified realmode code it
> should be easy - let me hack up a patch in the morning.

Neither s3_beep nor s3_leds (this patch: 
https://lists.ubuntu.com/archives/kernel-team/2011-May/015621.html ) worked 
for me so I thing that BIOS breaks on resume before we can do anything.

> Robert Hancock <hancockrwd@gmail.com> wrote:
> >On 10/24/2012 02:09 PM, Alan Cox wrote:
> >> On Wed, 24 Oct 2012 12:36:04 -0700
> >>
> >> "H. Peter Anvin" <hpa@zytor.com> wrote:
> >>> Minor concern: it should do the wait for ready before sending each
> >
> >command.
> >
> >> Can we get a command line to do this quirk too - it strikes me that
> >
> >if
> >
> >> the MSIs rely upon it then it may be something Windows always does so
> >> will be useful to try on other problem machines as an experiment.
> >
> >I agree, one has to keep in mind the age-old question "how does Windows
> >
> >work?" since it surely has no such quirk. I'd say we're sometimes too
> >quick to add these DMI quirks when a more general solution would be
> >somehow figure out how the Linux behavior differs from what Windows is
> >doing.



-- 
Ondrej Zary
