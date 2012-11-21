Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757507Ab2KVUbb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Nov 2012 15:31:31 -0500
Received: from perches-mx.perches.com ([206.117.179.246]:32842 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1756536Ab2KVUbW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Nov 2012 15:31:22 -0500
Message-ID: <1353533099.24807.45.camel@joe-AO722>
Subject: Re: [PATCH RESEND] acpi: Fix logging when no pci_irq is allocated
From: Joe Perches <joe@perches.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: "Jan H." =?ISO-8859-1?Q?Sch=F6nherr?= <schnhrr@cs.tu-berlin.de>,
        Daniel J Blueman <daniel@numascale-asia.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 21 Nov 2012 13:24:59 -0800
In-Reply-To: <5752160.0Aavql38JJ@vostro.rjw.lan>
References: <1353487401-10279-1-git-send-email-daniel@numascale-asia.com>
	 <1483298.SPL34HcZVJ@vostro.rjw.lan> <1353531235.24807.39.camel@joe-AO722>
	 <5752160.0Aavql38JJ@vostro.rjw.lan>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-11-21 at 22:25 +0100, Rafael J. Wysocki wrote:
> On Wednesday, November 21, 2012 12:53:55 PM Joe Perches wrote:
> > I mean Jan Schönherr's patches that should fix this are
> > likely to be picked up one day.
> > 
> > https://lkml.org/lkml/2012/11/13/678
> 
> Till then, we need the patch you sent, right?  And it won't hurt to apply it
> anyway?

If it's a real problem for someone, I guess so.
It shouldn't hurt anything.

