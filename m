Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752240Ab2LTCHG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Dec 2012 21:07:06 -0500
Received: from mail-bk0-f41.google.com ([209.85.214.41]:42572 "EHLO
	mail-bk0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751234Ab2LTCG7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Dec 2012 21:06:59 -0500
MIME-Version: 1.0
In-Reply-To: <1855256.SyhOJGYMIh@vostro.rjw.lan>
References: <8498184.VilrUmatxI@vostro.rjw.lan>
	<1355789297.18964.334.camel@misato.fc.hp.com>
	<4082842.31rfDviYHK@vostro.rjw.lan>
	<1855256.SyhOJGYMIh@vostro.rjw.lan>
Date: Wed, 19 Dec 2012 18:06:57 -0800
X-Google-Sender-Auth: CAGKy6E40eamMA9Y_jo1GcRqj4E
Message-ID: <CAE9FiQXn9C4_eYUdSew-5H0fpHE7C0wCqsXORfrPvGFf2sK98A@mail.gmail.com>
Subject: Re: [PATCH 0/16] ACPI: Rework ACPI namespace scanning for devices
From: Yinghai Lu <yinghai@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Toshi Kani <toshi.kani@hp.com>, Bjorn Helgaas <bhelgaas@google.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-pci@vger.kernel.org,
        Myron Stowe <myron.stowe@redhat.com>,
        Yijing Wang <wangyijing0307@gmail.com>, Jiang Liu <liuj97@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 19, 2012 at 5:45 PM, Rafael J. Wysocki <rjw@sisk.pl> wrote:

great!, the .bind and .unbind go away.

>
> The patches are on top of my master branch and I'm going to rebase them when
> v3.8-rc1 is out.

>
> There is a git tree you can pull them from at:
>
> http://git.kernel.org/?p=linux/kernel/git/rafael/linux-pm.git;a=summary acpi-scan-temp-new
>
> It's v3.7 with my master branch merged and the new patches on top.


can you make it base to today's Linus tree ?

otherwise I have to do some manual merge...

Bjorn change the _PRT for v.3.8...

Thanks

Yinghai
