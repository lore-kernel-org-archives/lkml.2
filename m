Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758532Ab2IKR1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Sep 2012 13:27:39 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:47330 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753360Ab2IKR1h (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Sep 2012 13:27:37 -0400
Message-ID: <504F742D.6000701@linaro.org>
Date: Tue, 11 Sep 2012 10:26:05 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:15.0) Gecko/20120827 Thunderbird/15.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: prarit@redhat.com, xen-devel@lists.xensource.com,
        linaro-dev@lists.linaro.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        linux-pm@vger.kernel.org, Frederic Weisbecker <fweisbec@gmail.com>,
        richardcochran@gmail.com,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, linux-acpi@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, mingo@kernel.org,
        lenb@kernel.org
Subject: Re: CONFIG_NO_HZ + CONFIG_CPU_IDLE freeze the system (Was Re: [PATCH]
 acpi : remove power from acpi_processor_cx structure)
References: <1343164349-28550-1-git-send-email-daniel.lezcano@linaro.org> <201209062204.11288.rjw@sisk.pl> <50490920.9070204@linaro.org> <201209062318.42874.rjw@sisk.pl> <504A02BD.4000805@linaro.org> <504A2D73.3010702@linaro.org> <504A68A0.7010907@linaro.org> <504E1FE5.6090502@linaro.org> <504E4343.5070004@linaro.org> <504E8372.20904@linaro.org> <504EE124.3010401@linaro.org>
In-Reply-To: <504EE124.3010401@linaro.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12091117-7282-0000-0000-00000CE7E00F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/10/2012 11:58 PM, Daniel Lezcano wrote:
>> Would you mind testing the following patch? It seems to resolve the
>> issue, but I've not yet run it through my test suite to make sure it
>> didn't break anything else.
> No problem, I will try it this evening.
>
> Is this problem related to all 32bits arch ?
I believe so. Although it didn't appear in my 32bit testing w/ kvm, but 
I suspect that is due to my distro userland setting lots of timers so 
that we don't hit those multi-second idle times, which could overflow 
32bit nanoseconds, or maybe some other kvm quirk.

Anyway, let me know if your testing goes well.

Thanks so much again for noticing and bisecting this down.
-john

