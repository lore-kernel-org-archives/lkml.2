Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756341Ab0KVCcM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Nov 2010 21:32:12 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47193 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756166Ab0KVCcL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Nov 2010 21:32:11 -0500
Message-ID: <4CE9D5E2.9090706@zytor.com>
Date: Sun, 21 Nov 2010 18:30:58 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.12) Gecko/20101103 Fedora/1.0-0.33.b2pre.fc14 Thunderbird/3.1.6
MIME-Version: 1.0
To: Nigel Cunningham <lkml@nigelcunningham.com.au>
CC: Suresh Siddha <suresh.b.siddha@intel.com>, Ingo Molnar <mingo@elte.hu>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: Re: [patch] x86: avoid unnecessary smp alternatives switch during
 suspend/resume
References: <1290211764.2637.8.camel@sbsiddha-MOBL3.sc.intel.com> <4CE8E60D.9000303@nigelcunningham.com.au>
In-Reply-To: <4CE8E60D.9000303@nigelcunningham.com.au>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/21/2010 01:27 AM, Nigel Cunningham wrote:
> We have a few others things that want to modify their behaviour
> according to whether we're doing the atomic copy/restore. Perhaps it
> would be an idea to just use a single flag, perhaps a value for
> system_state?

system_state is pretty much considered harmful...

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

