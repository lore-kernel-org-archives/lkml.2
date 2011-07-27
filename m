Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754733Ab1G0QGi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Jul 2011 12:06:38 -0400
Received: from ch1ehsobe001.messaging.microsoft.com ([216.32.181.181]:15341
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754345Ab1G0QGg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Jul 2011 12:06:36 -0400
X-SpamScore: -11
X-BigFish: VPS-11(zzbb2dK1432N98dKzz1202hzzz32i668h839h61h)
X-Spam-TCS-SCL: 0:0
X-Forefront-Antispam-Report: CIP:163.181.249.108;KIP:(null);UIP:(null);IPVD:NLI;H:ausb3twp01.amd.com;RD:none;EFVD:NLI
X-WSS-ID: 0LP022T-01-4Q2-02
X-M-MSG: 
Message-ID: <4E303785.8000102@amd.com>
Date: Wed, 27 Jul 2011 12:06:29 -0400
From: Boris Ostrovsky <boris.ostrovsky@amd.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.18) Gecko/20110616 SUSE/3.1.11 Thunderbird/3.1.11
MIME-Version: 1.0
To: Andi Kleen <ak@linux.intel.com>
CC: Andi Kleen <andi@firstfloor.org>, "ostr@amd64.org" <ostr@amd64.org>,
        "jvpeetz@web.de" <jvpeetz@web.de>,
        "Petkov, Borislav" <Borislav.Petkov@amd.com>,
        "mingo@elte.hu" <mingo@elte.hu>, "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stable@kernel.org" <stable@kernel.org>,
        "tim.bird@am.sony.com" <tim.bird@am.sony.com>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>
Subject: Re: [PATCH] [25/98] x86, AMD: Fix APIC timer erratum 400 affecting
 K8 Rev.A-E processors
References: <20110726534.972201586@firstfloor.org> <20110727003517.6946C2403FF@tassilo.jf.intel.com> <4E3006DF.6010906@amd.com> <20110727154203.GB16180@tassilo.jf.intel.com>
In-Reply-To: <20110727154203.GB16180@tassilo.jf.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/27/11 11:42, Andi Kleen wrote:
>> Andi, this patch is unnecessary.
>>
>> It (as well as 328935e6348c6a7cb34798a68c326f4b8372e68a and
>> 14fb57dccb6e1defe9f89a66f548fcb24c374c1d) is superseded by
>> e9cdd343a5e42c43bcda01e609fa23089e026470 upstream
>
> Is it obsolete in 2.6.35 too?

Yes.

>
> So what should I do? Drop this one and merge some other?
> Or just drop?

Please drop it (and skip the other two that I mentioned above) and apply 
e9cdd343a5e42c43bcda01e609fa23089e026470.

>
> If yes why do the other ones not have Cc: stable marks?

That was a mistake on my part, sorry about this.


-boris

