Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754496Ab0IOQ2Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Sep 2010 12:28:25 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:16709 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752475Ab0IOQ2Y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Sep 2010 12:28:24 -0400
Date: Wed, 15 Sep 2010 09:26:46 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        driverdevel <devel@driverdev.osuosl.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gregkh@suse.de, Brett Rudley <brudley@broadcom.com>,
        Henry Ptasinski <henryp@broadcom.com>, Nohee Ko <noheek@broadcom.com>
Subject: Re: linux-next: Tree for September 15 (brcm80211)
Message-Id: <20100915092646.63fe20fd.randy.dunlap@oracle.com>
In-Reply-To: <20100915142954.6a36f52d.sfr@canb.auug.org.au>
References: <20100915142954.6a36f52d.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 15 Sep 2010 14:29:54 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100914:


When BRCM80211_PCI is not enabled:

make[4]: *** No rule to make target `drivers/staging/brcm80211/brcm80211.c', needed by `drivers/staging/brcm80211/brcm80211.o'.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
