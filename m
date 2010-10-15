Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756263Ab0JOPoo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 11:44:44 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:62747 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755119Ab0JOPom (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 11:44:42 -0400
Date: Fri, 15 Oct 2010 08:44:20 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, gregkh <greg@kroah.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        lud <linux-usb@vger.kernel.org>
Subject: Re: linux-next: Tree for October 15 (usb/xhci)
Message-Id: <20101015084420.6624796d.randy.dunlap@oracle.com>
In-Reply-To: <20101015165002.0b6e418f.sfr@canb.auug.org.au>
References: <20101015165002.0b6e418f.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Oct 2010 16:50:02 +1100 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20101014:


When CONFIG_PM is not enabled:

drivers/usb/host/xhci.c:675: error: implicit declaration of function 'usb_root_hub_lost_power'

Also, can xhci.c:xhci_suspend() and xhci_resume() be inside
#ifdef CONFIG_PM / #endif ?

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
