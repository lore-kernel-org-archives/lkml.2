Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753164Ab1LTWng (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Dec 2011 17:43:36 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:33438 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752228Ab1LTWnd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Dec 2011 17:43:33 -0500
MIME-Version: 1.0
In-Reply-To: <20111215030919.GA7713@kroah.com>
References: <1323309517.979.8.camel@mop> <20111209001145.GB9550@kroah.com>
 <CAPXgP12tds9gPKie+B6358XkhyP1K2fLFGw698-wwsuKx_bcew@mail.gmail.com>
 <1323444321.979.39.camel@mop> <20111209223454.GA24987@kroah.com>
 <CAPXgP11fwJ=9E-K4ZpZ-nhf-Ry9=+oX4r7F1mLchxLMmvj_8ZA@mail.gmail.com>
 <20111214012141.GA18215@kroah.com> <CAPXgP10ZVjy00H3g1YbGJz+e0=mP9hXfdeDT8pOLrDE-e5E5_A@mail.gmail.com>
 <20111215030919.GA7713@kroah.com>
From: Kay Sievers <kay.sievers@vrfy.org>
Date: Tue, 20 Dec 2011 23:43:12 +0100
Message-ID: <CAPXgP12nV-cuG-PKmR8Ov4q4WEgTLRb=4Wd8vf2D00rPCx7vyQ@mail.gmail.com>
Subject: Re: [PATCH-WIP] convert CPU sysdev class to a real subsytem (needed
 for CPU modaliases)
To: Greg KH <greg@kroah.com>
Cc: linux-kernel@vger.kernel.org, ak@linux.intel.com, trenn@suse.de,
        davej@redhat.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 15, 2011 at 04:09, Greg KH <greg@kroah.com> wrote:
> On Wed, Dec 14, 2011 at 03:11:34AM +0100, Kay Sievers wrote:

>> If all should be bisectable, we would need to merge these changes into
>> the cpu patch.
>>
>> The other two core patches, node and memory, could need arch fixes
>> too, but a quick grep did not reveal anything.
>
> I'll look at these tomorrow.

Here are the current patches with all sysdev stuff finally removed
from the kernel:
  http://git.kernel.org/?p=linux/kernel/git/kay/patches.git;a=tree

X86, power, s390 allyesconfig and allmodconfig compiles fine.

Kay
