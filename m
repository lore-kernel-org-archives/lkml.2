Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754266Ab2F1L6e (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Jun 2012 07:58:34 -0400
Received: from e28smtp01.in.ibm.com ([122.248.162.1]:48528 "EHLO
	e28smtp01.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752765Ab2F1L6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Jun 2012 07:58:32 -0400
Message-ID: <4FEC4680.1090006@linux.vnet.ibm.com>
Date: Thu, 28 Jun 2012 17:26:48 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:13.0) Gecko/20120605 Thunderbird/13.0
MIME-Version: 1.0
To: Daniel Lezcano <daniel.lezcano@linaro.org>
CC: trenn@suse.de, deepthi@linux.vnet.ibm.com, linux-acpi@vger.kernel.org,
        linux-pm@lists.linux-foundation.org, linux-pm@vger.kernel.org,
        lenb@kernel.org, rjw@sisk.pl, x86@kernel.org,
        linux-kernel@vger.kernel.org, linaro-dev@lists.linaro.org
Subject: Re: [PATCH v2] acpi: intel_idle : break dependency between modules
References: <201206271506.29034.trenn@suse.de> <1340873202-2476-1-git-send-email-daniel.lezcano@linaro.org> <4FEC3EF7.5020208@linux.vnet.ibm.com> <4FEC3FAB.20706@linaro.org>
In-Reply-To: <4FEC3FAB.20706@linaro.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
x-cbid: 12062811-4790-0000-0000-0000037256DB
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2012 04:57 PM, Daniel Lezcano wrote:
> On 06/28/2012 01:24 PM, Srivatsa S. Bhat wrote:
>> On 06/28/2012 02:16 PM, Daniel Lezcano wrote:
>>> When the system is booted with some cpus offline, the idle
>>> driver is not initialized. When a cpu is set online, the
>>> acpi code call the intel idle init function. Unfortunately
>>> this code introduce a dependency between intel_idle and acpi.
>>>
>>> This patch is intended to remove this dependency by using the
>>> notifier of intel_idle. This patch has the benefit of
>>> encapsulating the intel_idle driver and remove some exported
>>> functions.
>>>
>>> Signed-off-by: Daniel Lezcano <daniel.lezcano@linaro.org>
>>
>>
>> Looks good to me.
> 
> Thanks for the review Srivatsa.
> 
> Shall I consider it as an acked-by ?
> 

Sure, go ahead! :-)

Regards,
Srivatsa S. Bhat

