Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754198Ab1FBFJd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jun 2011 01:09:33 -0400
Received: from mga02.intel.com ([134.134.136.20]:19210 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751908Ab1FBFJc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jun 2011 01:09:32 -0400
X-ExtLoop1: 1
Message-ID: <4DE71B09.70304@intel.com>
Date: Thu, 02 Jun 2011 13:09:29 +0800
From: Huang Ying <ying.huang@intel.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110510 Iceowl/1.0b2 Icedove/3.1.10
MIME-Version: 1.0
To: Jesse Barnes <jbarnes@virtuousgeek.org>
CC: Len Brown <lenb@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Andi Kleen <andi@firstfloor.org>, "Luck, Tony" <tony.luck@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "Zhang, Yanmin" <yanmin.zhang@intel.com>
Subject: Re: [PATCH 7/9] PCIe, AER, add aer_recover_queue
References: <1305619719-7480-1-git-send-email-ying.huang@intel.com>	<1305619719-7480-8-git-send-email-ying.huang@intel.com> <20110601114937.69d69916@jbarnes-desktop>
In-Reply-To: <20110601114937.69d69916@jbarnes-desktop>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi, Jesse,

On 06/02/2011 02:49 AM, Jesse Barnes wrote:
> On Tue, 17 May 2011 16:08:37 +0800
> Huang Ying <ying.huang@intel.com> wrote:
> 
>> In addition to native PCIe AER, now APEI (ACPI Platform Error
>> Interface) GHES (Generic Hardware Error Source) can be used to report
>> PCIe AER errors too.  To add support to APEI GHES PCIe AER recovery,
>> aer_recover_queue is added to export the recovery function in native
>> PCIe AER driver.
>>
>> Recoverable PCIe AER errors are reported via NMI in APEI GHES.  Then
>> APEI GHES uses irq_work to delay the error processing into an IRQ
>> handler.  But PCIe AER recovery can be very time-consuming, so
>> aer_recover_queue, which can be used in IRQ handler, delays the real
>> recovery action into the process context, that is, work queue.
> 
> Have the dependencies for this already landed?  Or does this one need
> to go first?

This patch has no external dependencies and can go first.

Best Regards,
Huang Ying
