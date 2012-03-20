Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758211Ab2CTVbx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Mar 2012 17:31:53 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:48344 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754597Ab2CTVbv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Mar 2012 17:31:51 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dI9371I1432N98dKzz1202hzzz2fh668h839h93fhd25h)
X-Forefront-Antispam-Report: CIP:160.33.98.74;KIP:(null);UIP:(null);IPV:NLI;H:mail7.fw-bc.sony.com;RD:mail7.fw-bc.sony.com;EFVD:NLI
Message-ID: <4F68F731.1040908@am.sony.com>
Date: Tue, 20 Mar 2012 14:31:29 -0700
From: Tim Bird <tim.bird@am.sony.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.12) Gecko/20100907 Fedora/3.0.7-1.fc12 Thunderbird/3.0.7
MIME-Version: 1.0
To: Jason Wessel <jason.wessel@windriver.com>
CC: "kgdb-bugreport@lists.sourceforge.net" 
	<kgdb-bugreport@lists.sourceforge.net>,
        linux kernel <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kdb: Add message about CONFIG_DEBUG_RODATA on failure
 to install breakpoint
References: <4E7A4413.5000307@am.sony.com> <4F68CD32.3040202@windriver.com>
In-Reply-To: <4F68CD32.3040202@windriver.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: am.sony.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/20/2012 11:32 AM, Jason Wessel wrote:
> On 09/21/2011 03:07 PM, Tim Bird wrote:
>> On x86, if CONFIG_DEBUG_RODATA is set, one cannot set breakpoints
>> via KDB.  Apparently this is a well-known problem, as at least one distribution
>> now ships with both KDB enabled and CONFIG_DEBUG_RODATA=y for security reasons.
>>
>> This patch just adds an extra printk message to the breakpoint failure case,
>> in order to provide some useful diagnostics to the user.
>>
> 
> The patch is definitely the right idea.  I believe we should try and tell the whole story and only print the message for the type of breakpoint that fails.  It is absolutely the case that you can still use kdb/kdb without recompiling the kernel.
> 
> I propose a slightly different implementation below.

The new patch looks fine.
 -- Tim

=============================
Tim Bird
Architecture Group Chair, CE Workgroup of the Linux Foundation
Senior Staff Engineer, Sony Network Entertainment
=============================

