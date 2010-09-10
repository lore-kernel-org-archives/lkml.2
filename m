Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754855Ab0IJW7M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Sep 2010 18:59:12 -0400
Received: from terminus.zytor.com ([198.137.202.10]:49757 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753363Ab0IJW7L (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Sep 2010 18:59:11 -0400
Message-ID: <4C8AB80F.6020802@zytor.com>
Date: Fri, 10 Sep 2010 15:58:23 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.8) Gecko/20100806 Fedora/3.1.2-1.fc13 Thunderbird/3.1.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Huang Ying <ying.huang@intel.com>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: [RFC 1/6] x86, NMI, Add symbol definition for NMI magic constants
References: <1284087065-32722-1-git-send-email-ying.huang@intel.com> <1284151027.402.123.camel@laptop>
In-Reply-To: <1284151027.402.123.camel@laptop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2010 01:37 PM, Peter Zijlstra wrote:
> On Fri, 2010-09-10 at 10:51 +0800, Huang Ying wrote:
>> +       return inb(NMI_REASON_PORT);
> 
> I've always wondered, where is this magic stuff documented?
> 

A lot of the pre-2000 stuff is documented in Ralf Brown's Interrupt
List, and the associated book "The Undocumented PC".  A lot was
originally documented in various now-out-of-print IBM technical manuals.

RBIL unfortunately hasn't been updated since 2000.  The good news is
that post 2000 there are a lot more formal standards out there, but not
collected in one convenient place like that.

	-hpa
