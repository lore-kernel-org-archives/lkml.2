Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757148Ab1LBQvL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Dec 2011 11:51:11 -0500
Received: from e28smtp06.in.ibm.com ([122.248.162.6]:52685 "EHLO
	e28smtp06.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756873Ab1LBQvJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Dec 2011 11:51:09 -0500
Message-ID: <4ED901F5.3080302@linux.vnet.ibm.com>
Date: Fri, 02 Dec 2011 22:21:01 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:7.0) Gecko/20110927 Thunderbird/7.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>
CC: Borislav Petkov <bp@amd64.org>, mingo@elte.hu, tglx@linutronix.de,
        linux-kernel@vger.kernel.org, hpa@zytor.com
Subject: Re: [PATCH] x86: fix error paths in microcode_init()
References: <4ED8E2270200007800065120@nat28.tlf.novell.com> <20111202143517.GA16690@gere.osrc.amd.com> <4ED8F46E0200007800065178@nat28.tlf.novell.com> <4ED8EB7D.5070802@linux.vnet.ibm.com> <20111202152403.GB16690@gere.osrc.amd.com> <4ED8FDE102000078000651E5@nat28.tlf.novell.com> <4ED8FF7C.2090509@linux.vnet.ibm.com> <4ED90EBF02000078000652BE@nat28.tlf.novell.com>
In-Reply-To: <4ED90EBF02000078000652BE@nat28.tlf.novell.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 11120216-9574-0000-0000-000000630457
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2011 10:15 PM, Jan Beulich wrote:

>>>> On 02.12.11 at 17:40, "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
>> And if Boris is indeed going to take this patch, Jan, feel free to add
>> your "Signed-off-by" (if you agree to the code below) since I would like
>> to give due credit to you for pointing out the missing parts.
> 
> Feel free to add that or an acked-by.


Wow! Good to know that we have an agreement :-)
Boris, it is again up to you to choose among the two(Signed-off-by or Acked-by)
for Jan. Hehe ;-)

Thanks,
Srivatsa S. Bhat

