Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757283Ab0E2Dk5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 May 2010 23:40:57 -0400
Received: from vms173011pub.verizon.net ([206.46.173.11]:35765 "EHLO
	vms173011pub.verizon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751288Ab0E2Dky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 May 2010 23:40:54 -0400
Date: Fri, 28 May 2010 23:40:49 -0400 (EDT)
From: Len Brown <lenb@kernel.org>
X-X-Sender: lenb@localhost.localdomain
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
       Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       linux-acpi@vger.kernel.org
Subject: Re: [git pull request] ACPI patches for 2.6.35-merge
In-reply-to: <201005290036.34495.rjw@sisk.pl>
Message-id: <alpine.LFD.2.00.1005282337210.3942@localhost.localdomain>
References: <alpine.LFD.2.00.1005281641080.4045@localhost.localdomain>
 <201005290036.34495.rjw@sisk.pl>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
MIME-version: 1.0
Content-type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


> Hmm, it looks like you omitted these two:
> 
> https://patchwork.kernel.org/patch/91560/
> https://patchwork.kernel.org/patch/91558/
> 
> Was that intentional or were they simply forgotten?

I missed those two.
Strange --  I recall discussing them in April,
so don't know why they were not in my test tree since then.

Anyway, they're in acpi-test now, and as it is a bug fix,
with just a small re-name, should be fine for the next push.

thanks,
-Len Brown, Intel Open Source Technology Center


