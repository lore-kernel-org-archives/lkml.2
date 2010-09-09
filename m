Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755114Ab0IIQ2O (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Sep 2010 12:28:14 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:64902 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751486Ab0IIQ2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Sep 2010 12:28:12 -0400
Date: Thu, 9 Sep 2010 09:26:45 -0700
From: Randy Dunlap <randy.dunlap@oracle.com>
To: Stephen Rothwell <sfr@canb.auug.org.au>, lud <linux-usb@vger.kernel.org>
Cc: linux-next@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>,
        gregkh@suse.de, Alan Cox <alan@linux.intel.com>,
        Alek Du <alek.du@intel.com>
Subject: Re: linux-next: Tree for September 9 (usb/otg/langwell)
Message-Id: <20100909092645.11fc3bf0.randy.dunlap@oracle.com>
In-Reply-To: <20100909211249.2c70ac41.sfr@canb.auug.org.au>
References: <20100909211249.2c70ac41.sfr@canb.auug.org.au>
Organization: Oracle Linux Eng.
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.16.6; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 9 Sep 2010 21:12:49 +1000 Stephen Rothwell wrote:

> Hi all,
> 
> Changes since 20100908:

on i386 (X86_32), drivers/usb/otg/langwell_otg.c has 429 errors and 2 warnings.

Examples:

include/linux/usb/langwell_otg.h:23:37: error: linux/usb/intel_mid_otg.h: No such file or directory
include/linux/usb/langwell_otg.h:115: error: field 'iotg' has incomplete type
include/linux/usb/langwell_otg.h:136: warning: type defaults to 'int' in declaration of '__mptr'
include/linux/usb/langwell_otg.h:136: warning: initialization from incompatible pointer type
drivers/usb/otg/langwell_otg.c:251: error: dereferencing pointer to incomplete type
drivers/usb/otg/langwell_otg.c:520: warning: its scope is only this definition or declaration, which is probably not what you want
drivers/usb/otg/langwell_otg.c:904: error: 'MID_OTG_NOTIFY_CONNECT' undeclared (first use in this function)
drivers/usb/otg/langwell_otg.c:2132 : error: implicit declaration of function 'intel_mid_otg_register_notifier'
drivers/usb/otg/langwell_otg.c:2191 : error: implicit declaration of function 'intel_mid_otg_unregister_notifier'


Note the missing header file.

---
~Randy
*** Remember to use Documentation/SubmitChecklist when testing your code ***
