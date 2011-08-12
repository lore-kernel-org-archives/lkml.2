Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab1HLV7Y (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Aug 2011 17:59:24 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:33142 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752503Ab1HLV7X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Aug 2011 17:59:23 -0400
Date: Sat, 13 Aug 2011 05:59:04 +0800 (SGT)
From: Jeff Chua <jeff.chua.linux@gmail.com>
X-X-Sender: root@boston.corp.fedex.com
To: Bjorn Helgaas <bhelgaas@google.com>
cc: Andrey Panin <pazke@centrinvest.ru>, lkml <linux-kernel@vger.kernel.org>,
        Matthew Garrett <mjg@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: How to access serial port that is set in BIOS as OS Controlled
Message-ID: <Pine.LNX.4.64.1108130553490.22593@boston.corp.fedex.com>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Sat, Aug 13, 2011 at 2:07 AM, Bjorn Helgaas <bhelgaas@google.com> 
wrote:
> On Fri, Aug 12, 2011 at 1:01 AM, Jeff Chua <jeff.chua.linux@gmail.com> 
wrote:
> I think this is all working as expected now.  PNP automatically 
> configures the port and enables it.  The 8250_pnp driver automatically 
> claims it.  And I assume the port "just works" without any setserial or 
> sysfs manipulations at all.  Does that solve your issue?

Yes, it solved my issue:) Big thanks to you!


> We need to think a bit more about whether this the right approach for 
> handling _SRS and whether it's in the right place.  But I think this is 
> a start, at least.

Agreed.

Please push the patch to Linus so he can include it to his tree to solve 
os-controlled devices so they can automatically be used under Linux.


Thank you Andrey and Bjorn for helping out!


Thanks,
Jeff
