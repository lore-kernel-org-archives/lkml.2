Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754251Ab1D0Dad (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 23:30:33 -0400
Received: from csamuel.org ([74.50.50.137]:34352 "EHLO csamuel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750837Ab1D0Dac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 23:30:32 -0400
Message-ID: <4DB78DC6.90706@csamuel.org>
Date: Wed, 27 Apr 2011 13:30:14 +1000
From: Chris Samuel <chris@csamuel.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
CC: mingo@redhat.com, hpa@zytor.com, thomas@m3y3r.de,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] x86, setup: When probing memory with e801, use
 ax/bx as a pair
References: <1303566747.12067.10.camel@localhost.localdomain> <tip-39b68976ac653cfdc7f872a293e8b7928de2dcc6@git.kernel.org> <201104261450.15786.chris@csamuel.org> <20110426081237.GD806@elte.hu>
In-Reply-To: <20110426081237.GD806@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ingo,

On 26/04/11 18:12, Ingo Molnar wrote:

> Just asking, does the box now boot to user-space, or are there other 
> regressions left?

Well I now have to boot the box with "noapic" otherwise I hit
IRQ problems in the e100 and aic7xxx drivers, they report:

can't find IRQ for PCI INT A; probably buggy MP table

Even with "noapic" the user space seems to try and load the
software RAID before the SCSI driver resulting in it timing
out locating the root filesystem and resetting the box.  I
suspect that may be an initramfs issue though..

cheers,
Chris
-- 
 Chris Samuel  :  http://www.csamuel.org/  :  Melbourne, VIC
