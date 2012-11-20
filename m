Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753260Ab2KTBfN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 20:35:13 -0500
Received: from g4t0016.houston.hp.com ([15.201.24.19]:17345 "EHLO
	g4t0016.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752135Ab2KTBfL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 20:35:11 -0500
Message-ID: <1353374815.10939.95.camel@misato.fc.hp.com>
Subject: Re: [PATCH v5 RESEND 1/5] ACPI: Add acpi_pr_<level>() interfaces
From: Toshi Kani <toshi.kani@hp.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Joe Perches <joe@perches.com>, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        imammedo@redhat.com, prarit@redhat.com
Date: Mon, 19 Nov 2012 18:26:55 -0700
In-Reply-To: <1914456.6xpKcjJgfG@vostro.rjw.lan>
References: <1352214130-12055-1-git-send-email-toshi.kani@hp.com>
	 <1458606.kpqnW2s3Q0@vostro.rjw.lan>
	 <1353346003.10939.54.camel@misato.fc.hp.com>
	 <1914456.6xpKcjJgfG@vostro.rjw.lan>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4 (3.4.4-2.fc17) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2012-11-20 at 02:04 +0100, Rafael J. Wysocki wrote:
> On Monday, November 19, 2012 10:26:43 AM Toshi Kani wrote:
> > On Mon, 2012-11-19 at 18:35 +0100, Rafael J. Wysocki wrote:
> > > On Monday, November 19, 2012 09:16:52 AM Toshi Kani wrote:
> > > > On Mon, 2012-11-19 at 08:06 -0800, Joe Perches wrote:
> > > > > On Mon, 2012-11-19 at 08:51 -0700, Toshi Kani wrote:
> > > > > > On Mon, 2012-11-19 at 00:56 -0800, Joe Perches wrote:
> > > > > > > is acpi_bus.h really the right file for these prototypes?
> > > > > > This interface is limited for ACPI, so it should be declared in a header
> > > > > > file under include/acpi.  Among the files in this directory, acpi_bus.h
> > > > > > seems to be a good fit as it declares the interfaces provided by ACPI
> > > > > > core.
> > > > > 
> > > > > I'd've put them in acpi.h or maybe created acpi_utils.h 
> > > > 
> > > > Hi Joe,
> > > > 
> > > > We cannot use acpi.h since it is an ACPICA header.
> > > 
> > > Which acpi.h are you referring to?
> > 
> > 
> > I was referring "include/acpi/acpi.h".
> 
> There is another acpi.h in include/linux that can be used for this purpose.

I see.  I agree that include/linux/acpi.h can be used.  I will update
the patchset to use this header.

Thanks,
-Toshi


