Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753576Ab2KSRal (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Nov 2012 12:30:41 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:53309 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753370Ab2KSRaj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Nov 2012 12:30:39 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Joe Perches <joe@perches.com>, linux-acpi@vger.kernel.org, lenb@kernel.org,
        linux-kernel@vger.kernel.org, bhelgaas@google.com,
        isimatu.yasuaki@jp.fujitsu.com, vijaymohan.pandarathil@hp.com,
        imammedo@redhat.com, prarit@redhat.com
Subject: Re: [PATCH v5 RESEND 1/5] ACPI: Add acpi_pr_<level>() interfaces
Date: Mon, 19 Nov 2012 18:35:06 +0100
Message-ID: <1458606.kpqnW2s3Q0@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353341812.10939.52.camel@misato.fc.hp.com>
References: <1352214130-12055-1-git-send-email-toshi.kani@hp.com> <1353341192.5287.9.camel@joe-AO722> <1353341812.10939.52.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 19, 2012 09:16:52 AM Toshi Kani wrote:
> On Mon, 2012-11-19 at 08:06 -0800, Joe Perches wrote:
> > On Mon, 2012-11-19 at 08:51 -0700, Toshi Kani wrote:
> > > On Mon, 2012-11-19 at 00:56 -0800, Joe Perches wrote:
> > > > is acpi_bus.h really the right file for these prototypes?
> > > This interface is limited for ACPI, so it should be declared in a header
> > > file under include/acpi.  Among the files in this directory, acpi_bus.h
> > > seems to be a good fit as it declares the interfaces provided by ACPI
> > > core.
> > 
> > I'd've put them in acpi.h or maybe created acpi_utils.h 
> 
> Hi Joe,
> 
> We cannot use acpi.h since it is an ACPICA header.

Which acpi.h are you referring to?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
