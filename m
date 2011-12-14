Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756586Ab1LNAvW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 19:51:22 -0500
Received: from mail-gy0-f174.google.com ([209.85.160.174]:35657 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756492Ab1LNAvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 19:51:18 -0500
MIME-Version: 1.0
In-Reply-To: <20111209223454.GA24987@kroah.com>
References: <1323309517.979.8.camel@mop> <20111209001145.GB9550@kroah.com>
 <CAPXgP12tds9gPKie+B6358XkhyP1K2fLFGw698-wwsuKx_bcew@mail.gmail.com>
 <1323444321.979.39.camel@mop> <20111209223454.GA24987@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Wed, 14 Dec 2011 01:50:57 +0100
Message-ID: <CAPXgP11fwJ=9E-K4ZpZ-nhf-Ry9=+oX4r7F1mLchxLMmvj_8ZA@mail.gmail.com>
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed
 for CPU modaliases)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 9, 2011 at 23:34, Greg KH <greg@kroah.com> wrote:
> On Fri, Dec 09, 2011 at 04:25:21PM +0100, Kay Sievers wrote:
>> Greg, would be nice, if you can take a quick look a the driver core (not
>> the sysdev) bits in core.c, bus.c, device.h, ... and its interaction, if
>> they look sane to you. I'll then split the driver core stuff out, so we
>> can merge that before we port the individual drivers over.
>
> Yes, it looks sane to me, thanks again for doing this work.

Split-up patches are here:
  http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=tree

That's the size of it:
  60 files changed, 1170 insertions(+), 1421 deletions(-)

The current state and the list of the remaining non-x86 files is here:
  http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=blob;f=README;hb=HEAD

We need a plan now. :)

Kay
