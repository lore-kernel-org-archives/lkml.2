Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754348Ab2HBN1z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Aug 2012 09:27:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57656 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753872Ab2HBN1y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Aug 2012 09:27:54 -0400
Date: Thu, 2 Aug 2012 15:24:34 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Roland McGrath <roland@hack.frob.com>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org, ananth@in.ibm.com,
        a.p.zijlstra@chello.nl, mingo@redhat.com, srikar@linux.vnet.ibm.com
Subject: Re: Q: user_enable_single_step() && update_debugctlmsr()
Message-ID: <20120802132434.GA3019@redhat.com>
References: <20120801140121.GA5333@redhat.com> <50193B5C.90404@linutronix.de> <20120801143132.GA7550@redhat.com> <5019427B.1070002@linutronix.de> <20120801150119.GA8845@redhat.com> <50194750.2050601@linutronix.de> <20120801151442.GA9697@redhat.com> <50197994.4090800@linutronix.de> <20120802130509.GA1465@redhat.com> <501A7E94.4030309@linutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <501A7E94.4030309@linutronix.de>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/02, Sebastian Andrzej Siewior wrote:
>
>>> From the link above,
>>
>> 	We have the GDB process and the (stopped) tracee T. And we have
>> 	another task X
>>          ^^^^^^^^^^^^^^
>
> Yes that is correct. Let me try to figure out how to plumb that leak
> and fix this before playing with it further.

I'll send 2 patches today. the 1st one adds the helper, the 2nd patch
fixes the usage of update_debugctlmsr().

Oleg.

