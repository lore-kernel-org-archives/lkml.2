Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754856Ab0ERGy3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 02:54:29 -0400
Received: from fgwmail7.fujitsu.co.jp ([192.51.44.37]:57351 "EHLO
	fgwmail7.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752699Ab0ERGyZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 02:54:25 -0400
X-SecurityPolicyCheck-FJ: OK by FujitsuOutboundMailChecker v1.3.1
Message-ID: <4BF2392A.9040409@jp.fujitsu.com>
Date: Tue, 18 May 2010 15:52:26 +0900
From: Hidetoshi Seto <seto.hidetoshi@jp.fujitsu.com>
User-Agent: Mozilla/5.0 (Windows; U; Windows NT 6.0; ja; rv:1.9.1.9) Gecko/20100317 Thunderbird/3.0.4
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
       bluesmoke-devel@lists.sourceforge.net,
       Linux Edac Mailing List <linux-edac@vger.kernel.org>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
       Ben Woodard <woodard@redhat.com>, Matt Domsch <Matt_Domsch@dell.com>,
       Doug Thompson <dougthompson@xmission.com>,
       Borislav Petkov <bp@amd64.org>, Tony Luck <tony.luck@intel.com>,
       Brent Young <brent.young@intel.com>
Subject: Re: Hardware Error Kernel Mini-Summit
References: <4BF18995.6070008@redhat.com>
In-Reply-To: <4BF18995.6070008@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

(2010/05/18 3:23), Mauro Carvalho Chehab wrote:
> During the last LF Collaboration Summit, we've done a mini-summit [1],
> intended to improve the hardware error detection in kernel, currently
> provided by MCE and EDAC subsystems.
> 
> The idea of this mini-summit came up after Thomas Gleixner and Ingo
> Molnar suggestions that edac and mce should converge into an error
> subsystem.
> 
> I'm enclosing the minutes of the meeting, in order to allow it to be
> reviewed by other kernel hackers that are interested on the theme but
> unfortunately couldn't come to the meeting.
> 
> Btw, during the meeting, it were decided that EDAC ML could better work
> if moved to vger, so I'm copying here both the old and the new edac
> mailing lists.
> 
> [1] http://events.linuxfoundation.org/lfcs2010/edac
> 
> ---

Thank you very much for providing this report.

I agree that we should have a well organized error subsystem that
covers all error sources in the system and that provides enough
simple and powerful API for users. As one of interested absentee,
I think I could be of some help to you (e.g. x86 low level).

It might be off-topic here, but I'd like to point that you missed
the presence of PCIe AER subsystem that handle hardware errors on
PCIe devices nowadays (It works well on ppc, x86 and so on).
Given that APEI also covers PCIe errors and that some system can
map MC registers to PCI configuration space, I think there is no
way for the new error subsystem to ignore I/O device errors while
it care errors on CPU/memory and cooperate with APEI.


Thanks,
H.Seto

