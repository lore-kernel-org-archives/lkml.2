Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751772Ab2AQD61 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Jan 2012 22:58:27 -0500
Received: from mail-gx0-f174.google.com ([209.85.161.174]:62468 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab2AQD6Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Jan 2012 22:58:25 -0500
MIME-Version: 1.0
In-Reply-To: <CANuKePk9LWEuFe3zrh0RiKtau85DAEBHbd+Qow10Py80xzYYtg@mail.gmail.com>
References: <CANuKePk9LWEuFe3zrh0RiKtau85DAEBHbd+Qow10Py80xzYYtg@mail.gmail.com>
Date: Tue, 17 Jan 2012 11:58:25 +0800
Message-ID: <CANuKePmkw3=aXoB-y4m_ULnePR-PsYH2yUApd3K7fs4Qxt4FBw@mail.gmail.com>
Subject: Re: how to Identify and determine NMI sourcing in GHES.c ? for
 example , knowing a NMI error is caused by pcie error
From: Lin-Bao Zhang <2004.zhang@gmail.com>
To: ying.huang@intel.com, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> In firmware first mode (BIOS hold AER service control), AER will be reported via
> APEI HEST Generic Hardware Error Source, AER will be logged by kernel there.
> AER recovery can be triggered there too, but the code has not been merged by
> Linux kernel upstream yet.

Wow! ,from LKML , I have found your patches here :
http://www.spinics.net/lists/linux-acpi/msg34003.html
I check the latest code from
http://lxr.linux.no/linux+v3.2.1/drivers/acpi/apei/ghes.c ,this patch
has been not adopted by upstream.

another question :
for corrected error , hardware can correct it.
but for uncorrected error, especially fatal error , machines need to
be restarted immediately, but for OS ,for different error (NMI
sourcing) ,OS needs to do different ready works before restarting
machine ?

thanks .

-Bob Zhang
