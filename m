Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752594Ab0HWLyu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Aug 2010 07:54:50 -0400
Received: from novprvlin0050.provo.novell.com ([137.65.248.33]:9287 "EHLO
	novprvlin0050.provo.novell.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751455Ab0HWLyt (ORCPT
	<rfc822;groupwise-jlee@novell.com:3:1>);
	Mon, 23 Aug 2010 07:54:49 -0400
Message-Id: <4C72EE25020000230001F28F@novprvlin0050.provo.novell.com>
X-Mailer: Novell GroupWise Internet Agent 8.0.2 
Date: Mon, 23 Aug 2010 05:54:45 -0600
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

於 二，2010-08-17 於 08:56 -0600，Joey Lee 提到：
> > I've thought about this a bit more and now lean towards thinking that 
> > putting the PCI IDs in the ACPI video driver is the best way to go. The 
> > alternative is to only fix it for MSI, which isn't the best option. On 
> 
> OK! Got it!
> I will try to put the PCI IDs in ACPI video driver then send out the
> patch for review ASAP.
> 

I just sand the "Add intel drm blacklist to intel_opregion_present
detect" patch to you and I put all Poulsbo/Morrestown PCI IDs in
blacklist in the patch.

> > the other hand, I looked at adding support to the Poulsbo driver and it 
> > actually seems pretty easy, so to be honest I'd prefer it if that got 
> > done instead.
> > 
> 
> I am not good for video driver, but will also try to look at it.
> 

I readed the following mail loop for Poulsbo drm driver:

http://sourceforge.net/mailarchive/message.php?msg_name=49C3CB88.2000202%40shipmail.org

Looks like GregKH is working on extract 2D video driver for
Poulsbo/Morrestown. We will need the 2D driver then add the opregion
support in Poulsbo 2D dirver like the Ironlake.


Thank's a lot!
Joey Lee

