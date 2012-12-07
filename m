Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756891Ab2LGVmr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Dec 2012 16:42:47 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:42360 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754633Ab2LGVmp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Dec 2012 16:42:45 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo7ck=D0U88-gTU61VLu3Fmomgxxe2vJunWJJC0RXGGoSw@mail.gmail.com>
References: <20121207062454.11051.12739.stgit@amt.stowe>
	<20121207062500.11051.44198.stgit@amt.stowe>
	<CAErSpo6MEtx6hsYhY=h0+eXqQcnZuG2vq=z_8Oz8tnksKZd7DA@mail.gmail.com>
	<CAE9FiQV6L2ZUEVHM2CCdqZfB9Yij7OGYZ-xsEpzCdXU2hSHnsQ@mail.gmail.com>
	<CAErSpo7ck=D0U88-gTU61VLu3Fmomgxxe2vJunWJJC0RXGGoSw@mail.gmail.com>
Date: Fri, 7 Dec 2012 13:42:43 -0800
X-Google-Sender-Auth: tzY_C4ft84FKVko-NzrSX1lr8iI
Message-ID: <CAE9FiQW4FY1=SVCoVVE7bcxR7EaAuabMuyNE=t=kECxYb2=Ajg@mail.gmail.com>
Subject: Re: [PATCH 01/15] PCI, acpiphp: Separate out hot-add support of pci
 host bridge
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: Myron Stowe <myron.stowe@redhat.com>, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 7, 2012 at 1:36 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> On Fri, Dec 7, 2012 at 2:30 PM, Yinghai Lu <yinghai@kernel.org> wrote:
>
> Sorry I missed that; I had only looked at a few patches adjacent to
> the one that split out this code.
>
> I still would like the code to be all in pci_root.c.

ok, I will rebase that to put them in pci_root.c
and send them out after you take

[PATCH 0/8] PCI, ACPI, x86: Reserve fw allocated resource for hot-add root bus

Yinghai
