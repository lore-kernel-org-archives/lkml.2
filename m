Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755836Ab0HQO4d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 10:56:33 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:15284 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751334Ab0HQO4b (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:1>);
	Tue, 17 Aug 2010 10:56:31 -0400
Message-Id: <4C6B2FBC020000230001ED68@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Tue, 17 Aug 2010 08:56:28 -0600
From: "Joey Lee" <jlee@novell.com>
To: <mjg59@srcf.ucam.org>
Cc: <gregkh@suse.de>, <trenn@suse.de>, <linux-kernel@vger.kernel.org>,
        <platform-driver-x86@vger.kernel.org>, <Dennis.Jansen@web.de>
Subject: Re: [PATCH] Support MSI Poulsbo netbook U110/U115
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Matthew, 

First, thank's for your kindy suggestion, it's good to us.

於 一，2010-08-16 於 16:56 +0100，Matthew Garrett 提到：
> On Fri, Aug 13, 2010 at 03:05:58AM -0600, Joey Lee wrote:
> > Hi Matthew, 
> > 
> > Dennis help me to ported this patch to 2.6.35, and it works as expected.
> > Could you please give me any suggestions for this patch?
> 
> I've thought about this a bit more and now lean towards thinking that 
> putting the PCI IDs in the ACPI video driver is the best way to go. The 
> alternative is to only fix it for MSI, which isn't the best option. On 

OK! Got it!
I will try to put the PCI IDs in ACPI video driver then send out the
patch for review ASAP.

> the other hand, I looked at adding support to the Poulsbo driver and it 
> actually seems pretty easy, so to be honest I'd prefer it if that got 
> done instead.
> 

I am not good for video driver, but will also try to look at it.


Thank's a lot!
Joey Lee

