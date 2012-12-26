Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab2LZUQZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Dec 2012 15:16:25 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:41771 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752447Ab2LZUQU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Dec 2012 15:16:20 -0500
MIME-Version: 1.0
In-Reply-To: <CAErSpo5sGAEO+kcqUsjyrmn_LAzmkWm4ok0c=rBaR_ErwBX23A@mail.gmail.com>
References: <1558789.gX8cmBgyDV@vostro.rjw.lan>
	<150695156.KNRhubloU5@vostro.rjw.lan>
	<CAErSpo5ZpUaHzYQEpR9Jh0MbcmjHfhKUQ-EpRJH1PNCHR_qnVg@mail.gmail.com>
	<5457615.T2WjKPXXC4@vostro.rjw.lan>
	<CAE9FiQUBpu+rUfnvOwDUm8PTYYVfann3SyhhL4k=54EyfRSmLg@mail.gmail.com>
	<CAErSpo5sGAEO+kcqUsjyrmn_LAzmkWm4ok0c=rBaR_ErwBX23A@mail.gmail.com>
Date: Wed, 26 Dec 2012 12:16:18 -0800
X-Google-Sender-Auth: n6aEBzwbOMbsygx5hp3yirU95bU
Message-ID: <CAE9FiQWr6-=kvrCXKEWFvUHHv6xbHKt-oAdt+VPUMphVUW4U4A@mail.gmail.com>
Subject: Re: [Alternative][PATCH] ACPI / PCI: Set root bridge ACPI handle in advance
From: Yinghai Lu <yinghai@kernel.org>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
        "linux-pci@vger.kernel.org" <linux-pci@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, Tony Luck <tony.luck@intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Jiang Liu <liuj97@gmail.com>,
        Myron Stowe <myron.stowe@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 26, 2012 at 12:10 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
> Do you have a reference for this?  I think this might have been true
> in the past, but I don't think it's true for any version of gcc we
> support for building Linux.

http://lkml.indiana.edu/hypermail/linux/kernel/0804.3/3600.html
