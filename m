Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752379Ab2GIVVB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jul 2012 17:21:01 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:38434 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751123Ab2GIVU7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jul 2012 17:20:59 -0400
MIME-Version: 1.0
In-Reply-To: <1341861422-25861-1-git-send-email-geert@linux-m68k.org>
References: <1341861422-25861-1-git-send-email-geert@linux-m68k.org>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Mon, 9 Jul 2012 15:20:37 -0600
Message-ID: <CAErSpo47VO7F=fY1CRS-uwvp4CsTNttk2tasszs5Fdo7j7RqMA@mail.gmail.com>
Subject: Re: Build regressions/improvements in v3.5-rc6
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
X-System-Of-Record: true
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Geert,

There are some PCI-related regressions here that I'd like to fix, but
I don't know where to start.  For example, these:

>   + drivers/pci/quirks.c: error: implicit declaration of function 'ioread32' [-Werror=implicit-function-declaration]:  => 3154:2
>   + drivers/pci/quirks.c: error: implicit declaration of function 'iowrite32' [-Werror=implicit-function-declaration]:  => 3144:2

I don't see these in an x86 build, so I assume these are from some
other arch or other config.  Can I tell which one?
