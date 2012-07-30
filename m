Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754697Ab2G3Og3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 10:36:29 -0400
Received: from aaar.vm.bytemark.co.uk ([80.68.92.230]:54218 "EHLO
	aaar.vm.bytemark.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754516Ab2G3Og1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 10:36:27 -0400
X-Greylist: delayed 600 seconds by postgrey-1.27 at vger.kernel.org; Mon, 30 Jul 2012 10:36:27 EDT
Message-ID: <1343658373.15432.18.camel@zakaz.uk.xensource.com>
From: Ian Campbell <ijc@hellion.org.uk>
To: Len Brown <lenb@kernel.org>
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org,
        Pavel Vasilyev <pavel@pavlinux.ru>, linux-kernel@vger.kernel.org,
        Len Brown <len.brown@intel.com>
Date: Mon, 30 Jul 2012 15:26:13 +0100
In-Reply-To: <5011F15A.3060007@kernel.org>
References: <Pine.LNX.4.44L0.1206301023540.29029-100000@netrider.rowland.org>
	 <5011F15A.3060007@kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.3-1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 62.200.22.2
X-SA-Exim-Mail-From: ijc@hellion.org.uk
Subject: Re: [PATCH] ACPI: replace strlen("string") with sizeof("string") -1
X-SA-Exim-Version: 4.2.1 (built Mon, 22 Mar 2010 06:51:10 +0000)
X-SA-Exim-Scanned: Yes (on hopkins.hellion.org.uk)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-07-26 at 21:39 -0400, Len Brown wrote:
> ...both give the number of chars in the string
> without the '\0', as strncmp() wants,
> but sizeof() is compile-time.

I thought gcc optimised strlen("string literal") into a compile time
constant too. It does in a little userspace test I just wrote, but I
didn't look at its behaviour with the kernel's strlen.

Ian.

