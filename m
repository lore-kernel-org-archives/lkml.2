Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752035Ab0JPAR4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Oct 2010 20:17:56 -0400
Received: from claw.goop.org ([74.207.240.146]:40751 "EHLO claw.goop.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751175Ab0JPARz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Oct 2010 20:17:55 -0400
Message-ID: <4CB8EF30.7060504@goop.org>
Date: Fri, 15 Oct 2010 17:17:52 -0700
From: Jeremy Fitzhardinge <jeremy@goop.org>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "mingo@redhat.com" <mingo@redhat.com>, "hpa@zytor.com" <hpa@zytor.com>,
        Jeremy Fitzhardinge <Jeremy.Fitzhardinge@citrix.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@elte.hu" <mingo@elte.hu>
CC: "Xen-devel@lists.xensource.com" <Xen-devel@lists.xensource.com>,
        Ian Campbell <Ian.Campbell@citrix.com>,
        "linux-tip-commits@vger.kernel.org" 
	<linux-tip-commits@vger.kernel.org>
Subject: Re: [Xen-devel] Re: [tip:irq/core] x86: xen: Sanitise sparse_irq
 handling
References: <tip-77dff1c755c3218691e95e7e38ee14323b35dbdb@git.kernel.org> <4CB8EE8A.5020900@goop.org>
In-Reply-To: <4CB8EE8A.5020900@goop.org>
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

 On 10/15/2010 05:15 PM, Jeremy Fitzhardinge wrote:
>  On 10/12/2010 01:29 PM, tip-bot for Thomas Gleixner wrote:
>> Commit-ID:  77dff1c755c3218691e95e7e38ee14323b35dbdb
>> Gitweb:     http://git.kernel.org/tip/77dff1c755c3218691e95e7e38ee14323b35dbdb
>> Author:     Thomas Gleixner <tglx@linutronix.de>
>> AuthorDate: Wed, 29 Sep 2010 17:37:10 +0200
>> Committer:  Thomas Gleixner <tglx@linutronix.de>
>> CommitDate: Tue, 12 Oct 2010 16:53:44 +0200
>>
>> x86: xen: Sanitise sparse_irq handling
>>
>> There seems to be more cleanups possible, but that's left to the xen
>> experts :)
> This causes the kernel to fail to boot under Xen.  The WARN_ON(res !=
> irq) triggers and nobody is very happy about the results.

Of course the really interesting question is whether this sparse irq
rework allows us to hang our extra per-irq information of the irq_data
structure now, rather than having to maintain all these auxiliary arrays?

Thanks,
    J
