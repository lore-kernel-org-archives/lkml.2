Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756656Ab2JQL1m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Oct 2012 07:27:42 -0400
Received: from e28smtp08.in.ibm.com ([122.248.162.8]:42149 "EHLO
	e28smtp08.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753009Ab2JQL1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Oct 2012 07:27:40 -0400
Message-ID: <507E9622.6090606@linux.vnet.ibm.com>
Date: Wed, 17 Oct 2012 16:57:30 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: Borislav Petkov <bp@alien8.de>, tony.luck@intel.com,
        gong.chen@linux.intel.com, ananth@in.ibm.com,
        masbock@linux.vnet.ibm.com, x86@kernel.org,
        linux-kernel@vger.kernel.org, bp@amd64.org, lcm@us.ibm.com,
        andi@firstfloor.org, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, gregkh@suse.de, linux-edac@vger.kernel.org
Subject: Re: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com> <20120912122516.3825.87838.stgit@localhost.localdomain> <505C51D8.6070402@linux.vnet.ibm.com> <20121017105940.GA14590@x1.osrc.amd.com>
In-Reply-To: <20121017105940.GA14590@x1.osrc.amd.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12101711-2000-0000-0000-000009816A5D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 04:29 PM, Borislav Petkov wrote:
>>>
>>> +static struct dev_ext_attribute dev_attr_bios_cmci_threshold = {
>>> +	__ATTR(bios_cmci_threshold, 0444, device_show_int, NULL),
>>> +	&mce_bios_cmci_threshold
>
> Ok, I just noticed this (we must've missed it during review) but why is
> this read-only? If it has to be read-only, why do we have a node for
> this in sysfs instead of simply issuing the printk statements below and
> people who are interested in this, can grep dmesg?

This was added so that user-space tools could find out if we're using 
thresholds for CMCI.

Regards,
Naveen

