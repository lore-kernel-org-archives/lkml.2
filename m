Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757761Ab1DHW6R (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Apr 2011 18:58:17 -0400
Received: from mail-gw0-f46.google.com ([74.125.83.46]:56115 "EHLO
	mail-gw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753453Ab1DHW6Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Apr 2011 18:58:16 -0400
Message-ID: <4D9F9301.5070204@codemonkey.ws>
Date: Fri, 08 Apr 2011 17:58:09 -0500
From: Anthony Liguori <anthony@codemonkey.ws>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.14) Gecko/20110223 Lightning/1.0b2 Thunderbird/3.1.8
MIME-Version: 1.0
To: Scott Wood <scottwood@freescale.com>
CC: Ingo Molnar <mingo@elte.hu>, Avi Kivity <avi@redhat.com>,
        Pekka Enberg <penberg@kernel.org>, linux-kernel@vger.kernel.org,
        aarcange@redhat.com, mtosatti@redhat.com, kvm@vger.kernel.org,
        joro@8bytes.org, penberg@cs.helsinki.fi, asias.hejun@gmail.com,
        gorcunov@gmail.com
Subject: Re: [ANNOUNCE] Native Linux KVM tool
References: <1301592656.586.15.camel@jaguar>	<4D982E89.8070502@redhat.com>	<BANLkTinbCAUqaKfmKaj-7GXTh9F2if0x+Q@mail.gmail.com>	<4D9847BC.9060906@redhat.com>	<4D98716D.9040307@codemonkey.ws>	<4D9873CD.3080207@redhat.com>	<20110406093333.GB6465@elte.hu>	<4D9E6F6E.9050709@codemonkey.ws> <20110408105952.5e7c2ffb@schlenkerla.am.freescale.net>
In-Reply-To: <20110408105952.5e7c2ffb@schlenkerla.am.freescale.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/08/2011 10:59 AM, Scott Wood wrote:
> On Thu, 7 Apr 2011 21:14:06 -0500
> Anthony Liguori<anthony@codemonkey.ws>  wrote:
>
>> If someone was going to seriously go about doing something like this, a
>> better approach would be to start with QEMU and remove anything non-x86
>> and all of the UI/command line/management bits and start there.
>>
>> There's nothing more I'd like to see than a viable alternative to QEMU
>> but ignoring any of the architectural mistakes in QEMU and repeating
>> them in a new project isn't going to get there.
> Supporting only a single architecture sounds like a significant
> architectural mistake...  only x86 deserves clean code?

No, you just have to start somewhere.  Since x86 is probably the 
ugliest, I think it's the best place to start.

Regards,

Anthony Liguori

> -Scott
>

