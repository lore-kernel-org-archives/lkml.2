Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758819Ab2IEPIS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Sep 2012 11:08:18 -0400
Received: from tx2ehsobe004.messaging.microsoft.com ([65.55.88.14]:52784 "EHLO
	tx2outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757067Ab2IEPIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Sep 2012 11:08:16 -0400
X-Forefront-Antispam-Report: CIP:163.181.249.109;KIP:(null);UIP:(null);IPV:NLI;H:ausb3twp02.amd.com;RD:none;EFVD:NLI
X-SpamScore: -9
X-BigFish: VPS-9(zzbb2dI98dI9371I146fI103dK1432I4015Izz1202hzzz2dh668h839hd25he5bhf0ah107ah1155h)
X-WSS-ID: 0M9VU1L-02-8VY-02
X-M-MSG: 
Message-ID: <50476A41.30908@amd.com>
Date: Wed, 5 Sep 2012 17:05:37 +0200
From: Andre Przywara <andre.przywara@amd.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120615 Thunderbird/13.0.1
MIME-Version: 1.0
To: Thomas Renninger <trenn@suse.de>
CC: "Rafael J. Wysocki" <rjw@sisk.pl>, Matthew Garret <mjg@redhat.com>,
        <linux-pm@vger.kernel.org>, <cpufreq@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Andreas Herrmann <andreas.herrmann3@amd.com>
Subject: Re: [PATCH 0/8 v2] acpi-cpufreq: Move modern AMD cpufreq support
 to acpi-cpufreq
References: <1346747289-8421-1-git-send-email-andre.przywara@amd.com> <201209051546.22590.rjw@sisk.pl> <201209051625.41769.trenn@suse.de>
In-Reply-To: <201209051625.41769.trenn@suse.de>
Content-Type: text/plain; charset="ISO-8859-2"; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginatorOrg: amd.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/05/2012 04:25 PM, Thomas Renninger wrote:
> On Wednesday, September 05, 2012 03:46:22 PM Rafael J. Wysocki wrote:
>> On Tuesday, September 04, 2012, Andre Przywara wrote:
>>> Hi,
>>>
>>
>> I have applied the whole series to the linux-next branch of the linux-pm.git

Thanks!

>> tree, but I'm quite unsure about [7/8].  Is it really necessary?  I mean, since
>> we want users to switch to a different driver anyway, which already has a knob
>> providing the functionality in question, what's the point really?
>
> Afaik this was mostly for compiler people or other developers doing
> benchmarks to be able to avoid fluctating numbers caused by turbo/boost
> mode.
>
> I don't know whether it's used by any userspace tool.

Well, at least we use it here in quite some scripts, both for testing 
and for benchmarking.
As this has been in for 2.5 year by now, I'd like to keep it for one or 
two more major releases and then remove it.

> If, it would certainly
> be an AMD specific tool for developers. If you (AMD) know a userspace tool
> out there it may make sense to keep it the one or other kernel round,
> otherwise I guess it can simply be deleted.
>
> I will add the functionality (to enable/disable turbo/boost mode)
> to cpupower userspace tool as soon as this is in.
> Shouldn't be much more than a -t option and a
> one liner to read out or set another cpufreq sysfs file.

Thanks, that would be nice.

Regards,
Andre.

-- 
Andre Przywara
AMD-Operating System Research Center (OSRC), Dresden, Germany

