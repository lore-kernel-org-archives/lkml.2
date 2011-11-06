Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708Ab1KFVQv (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Nov 2011 16:16:51 -0500
Received: from mailout-eu.gmx.com ([213.165.64.43]:35529 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752230Ab1KFVQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Nov 2011 16:16:49 -0500
X-Authenticated: #50610217
X-Provags-ID: V01U2FsdGVkX1+xTNB8teixYE6YskfHIj5QwyCD0FRnjfdmZUU3oH
	cRhUJkxPgWIY68
Date: Sun, 6 Nov 2011 22:16:39 +0100
From: Martin Nyhus <martin.nyhus@gmx.com>
To: Josh Boyer <jwboyer@redhat.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Jesse Barnes <jbarnes@virtuousgeek.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: pci_has_legacy_pm_support warning with 3.1+
Message-ID: <20111106221639.75ae0439@voldar>
In-Reply-To: <20111103192742.GA14216@zod.bos.redhat.com>
References: <20111103192742.GA14216@zod.bos.redhat.com>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.22.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 3 Nov 2011 15:27:43 -0400 Josh Boyer <jwboyer@redhat.com> wrote:
> We just got a report of someone tripping over a WARN_ON that has been in
> the PCI code for quite a while (line 607 of drivers/pci/pci-driver.c).
> I'm wondering if someone can make a bit more sense of it than I can and
> maybe figure out which driver in question is doing something wrong.
[...]
> The full report (filed by abrtd) can be found here:
> https://bugzilla.redhat.com/show_bug.cgi?id=751167

I'm seeing the same warning here, in my case with the sdhci-pci driver,
and the patch[0] mentioned in the report fixes the issue (applied on top
of c861cd3).

	Martin


[0] http://marc.info/?l=linux-mmc&m=132031499400574&w=2
