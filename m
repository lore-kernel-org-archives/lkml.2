Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751536Ab2JDVuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Oct 2012 17:50:18 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:59812 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab2JDVuN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Oct 2012 17:50:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Len Brown <lenb@kernel.org>, Bjorn Helgaas <bhelgaas@google.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH 0/4] ACPI: kill acpi_pci_root_start
Date: Thu, 04 Oct 2012 23:53:40 +0200
Message-ID: <15022838.BvGHsiOjXu@vostro.rjw.lan>
User-Agent: KMail/4.8.5 (Linux/3.4.6-2.10-desktop; KDE/4.8.5; x86_64; ; )
In-Reply-To: <CAE9FiQU=h8mchDHCQ31U-UpPhqmFiO_H5yX2uonsyOh3tK9DYA@mail.gmail.com>
References: <CAE9FiQWgvVqnTTeYFvxf1GxLcEEeRyN-uSKPdg3o69oCpm43sQ@mail.gmail.com> <16287303.8DVGGcjq5E@vostro.rjw.lan> <CAE9FiQU=h8mchDHCQ31U-UpPhqmFiO_H5yX2uonsyOh3tK9DYA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 of October 2012 14:31:46 Yinghai Lu wrote:
> On Thu, Oct 4, 2012 at 2:23 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> >>
> >> At last we could remove all acpi_bus_start workaround.
> >
> > Do I understand correctly that you just want to prevent acpi_pci_root_driver
> > from binding to the host bridge's struct acpi_device created while we're
> > walking the ACPI namespace?
> 
> yes, during hot add path.

Why exactly do you want to prevent that from happening?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
