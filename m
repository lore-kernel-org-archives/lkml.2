Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756121Ab2KVS5k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 13:57:40 -0500
Received: from ogre.sisk.pl ([193.178.161.156]:60340 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756082Ab2KVS4u convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 13:56:50 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Joe Perches <joe@perches.com>
Cc: Jan =?ISO-8859-1?Q?H=2E_Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND] acpi: Fix logging when no pci_irq is allocated
Date: Thu, 22 Nov 2012 01:14:07 +0100
Message-ID: <1965627.n0VXnptTiB@vostro.rjw.lan>
User-Agent: KMail/4.9.3 (Linux/3.7.0-rc6; KDE/4.9.3; x86_64; ; )
In-Reply-To: <1353533099.24807.45.camel@joe-AO722>
References: <1353487401-10279-1-git-send-email-daniel@numascale-asia.com> <5752160.0Aavql38JJ@vostro.rjw.lan> <1353533099.24807.45.camel@joe-AO722>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 21, 2012 01:24:59 PM Joe Perches wrote:
> On Wed, 2012-11-21 at 22:25 +0100, Rafael J. Wysocki wrote:
> > On Wednesday, November 21, 2012 12:53:55 PM Joe Perches wrote:
> > > I mean Jan Schönherr's patches that should fix this are
> > > likely to be picked up one day.
> > > 
> > > https://lkml.org/lkml/2012/11/13/678
> > 
> > Till then, we need the patch you sent, right?  And it won't hurt to apply it
> > anyway?
> 
> If it's a real problem for someone, I guess so.
> It shouldn't hurt anything.

So I've applied it.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
