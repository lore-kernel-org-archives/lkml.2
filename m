Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752201Ab2LJWwZ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Dec 2012 17:52:25 -0500
Received: from mail-1-out2.atlantis.sk ([80.94.52.71]:42674 "EHLO
	mail.atlantis.sk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751310Ab2LJWwY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Dec 2012 17:52:24 -0500
From: Ondrej Zary <linux@rainbow-software.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v3] Enable A20 using KBC for some MSI laptops to fix S3 resume
Date: Mon, 10 Dec 2012 23:51:40 +0100
User-Agent: KMail/1.9.10 (enterprise35 0.20100827.1168748)
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <201210261056.44225.zary@gsystems.sk> <201211052135.20009.linux@rainbow-software.org> <50C6537A.9090303@zytor.com>
In-Reply-To: <50C6537A.9090303@zytor.com>
X-KMail-QuotePrefix: > 
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline
Message-Id: <201212102351.41144.linux@rainbow-software.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 10 December 2012 22:26:18 H. Peter Anvin wrote:
> On 11/05/2012 12:35 PM, Ondrej Zary wrote:
> > On Friday 26 October 2012 10:56:44 Ondrej Zary wrote:
> >> Some MSI laptop BIOSes are broken - INT 15h code uses port 92h to enable
> >> A20 line but resume code assumes that KBC was used.
> >> The laptop will not resume from S3 otherwise but powers off after a
> >> while and then powers on again stuck with a blank screen.
> >>
> >> Fix it by enabling A20 using KBC. Affected laptop list and DMI data are
> >> from bug reports at Ubuntu Launchpad.
> >>
> >> Also add kernel parameter to easily activate this quirk on any system.
> >>
> >> Only compile tested. The original patch was tested with EX600 and PR200.
> >>
> >> Fixes https://bugzilla.kernel.org/show_bug.cgi?id=12878
> >
> > The bug was marked as RESOLVED CODE_FIX but I wonder what happened to
> > this patch. Was it applied? Or is someone working on a better way to fix
> > this problem?
>
> Sorry, I managed to forget about this.
>
> Is there any way you could test this patch by any chance?
>
> I would be a lot happier if this works as a general solution rather than
> relying on a quirk...

I have a PR200 laptop for a while now so I'll try to test this patch.


-- 
Ondrej Zary
