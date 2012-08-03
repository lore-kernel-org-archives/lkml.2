Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751679Ab2HCGON (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Aug 2012 02:14:13 -0400
Received: from e23smtp06.au.ibm.com ([202.81.31.148]:43730 "EHLO
	e23smtp06.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751056Ab2HCGOI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Aug 2012 02:14:08 -0400
Message-ID: <501B6C1E.3060503@linux.vnet.ibm.com>
Date: Fri, 03 Aug 2012 11:43:50 +0530
From: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120717 Thunderbird/14.0
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>
CC: Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, paulmck@linux.vnet.ibm.com,
        Thomas Renninger <trenn@suse.de>,
        Deepthi Dharwar <deepthi@linux.vnet.ibm.com>, stable@vger.kernel.org
Subject: Re: [PATCH v2] ACPI processor: Fix a typo error in commit 99b725084
References: <1343709883-16801-1-git-send-email-feng.tang@intel.com> <501B51F1.7090503@kernel.org>	<501B67F4.3030308@linux.vnet.ibm.com> <20120803140343.0f15eebd@feng-i7>
In-Reply-To: <20120803140343.0f15eebd@feng-i7>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
x-cbid: 12080306-7014-0000-0000-000001AB525D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/03/2012 11:33 AM, Feng Tang wrote:
> On Fri, 3 Aug 2012 11:26:04 +0530
> "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> wrote:
> 
>> On 08/03/2012 09:52 AM, Len Brown wrote:
>>> Applied.
>>>
>>> thanks for the refresh.
>>>
>>
>> This patch needs to be CC'ed to stable also right?
> 
> Yes, I've sent the patch directly to stable 3 days ago. thanks
> for the note.
> 

Hmm? Patches are not accepted into the stable tree until the patch
goes upstream, IIUC. And to make a patch automatically go to -stable
once it hits mainline, you need to add Cc: stable@vger.kernel.org
among the Signed-off-by sequence in the patch.

Otherwise, we can explicitly mail the patch to stable, -after- the
corresponding patch hits mainline.. In fact, we will also have to quote
the mainline commit id in that.

See Documentation/stable_kernel_rules.txt for details.

Regards,
Srivatsa S. Bhat

