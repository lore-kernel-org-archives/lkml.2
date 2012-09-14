Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751650Ab2INEHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Sep 2012 00:07:51 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54755 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750771Ab2INEHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Sep 2012 00:07:49 -0400
MIME-Version: 1.0
In-Reply-To: <87zk4t7pxv.fsf@write-only.cryp.to>
References: <87zk4t7pxv.fsf@write-only.cryp.to>
Date: Thu, 13 Sep 2012 22:07:47 -0600
Message-ID: <CABhMZUXH0cZSmjW_5oW1+XQZhR84S8LwWxk16Nuert4s3yo0xQ@mail.gmail.com>
Subject: Re: PROBLEM: ACPI 0x0000000000000b00-0x0000000000000b07 SystemIO
 conflicts with Region \_SB_.PCI0.SBRG.ASOC.SMRG 1 (20120320/utaddress-251)
From: Bjorn Helgaas <bjorn.helgaas@gmail.com>
To: Peter Simons <simons@cryp.to>
Cc: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 13, 2012 at 12:11 PM, Peter Simons <simons@cryp.to> wrote:
> Hi guys,
>
> I've recently updated my machine to Linux kernel 3.5. Ever since then, I
> experience frequent kernel panics in the I/O system. The output from
> dmesg shows the following warning, which earlier version of the kernel
> did not show:
>
>   ACPI 0x0000000000000b00-0x0000000000000b07 SystemIO conflicts with Region \_SB_.PCI0.SBRG.ASOC.SMRG 1 (20120320/utaddress-251)

The panic is the real problem, not the warning message.  It's possible
that they're related, but certainly not obvious.  Can you capture any
information about the panic with a serial console, netconsole, or even
a digital photo or movie?

It sounds like this is a regression, so it will be useful to know the
newest kernel that works correctly and the oldest one that fails.

Bjorn
