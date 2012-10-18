Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754169Ab2JRFn2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Oct 2012 01:43:28 -0400
Received: from e28smtp09.in.ibm.com ([122.248.162.9]:53968 "EHLO
	e28smtp09.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754070Ab2JRFn1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Oct 2012 01:43:27 -0400
Message-ID: <507F96F2.9050305@linux.vnet.ibm.com>
Date: Thu, 18 Oct 2012 11:13:14 +0530
From: "Naveen N. Rao" <naveen.n.rao@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121012 Thunderbird/16.0.1
MIME-Version: 1.0
To: "Luck, Tony" <tony.luck@intel.com>
CC: Borislav Petkov <bp@alien8.de>,
        "gong.chen@linux.intel.com" <gong.chen@linux.intel.com>,
        "ananth@in.ibm.com" <ananth@in.ibm.com>,
        "masbock@linux.vnet.ibm.com" <masbock@linux.vnet.ibm.com>,
        "x86@kernel.org" <x86@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "bp@amd64.org" <bp@amd64.org>, "lcm@us.ibm.com" <lcm@us.ibm.com>,
        "andi@firstfloor.org" <andi@firstfloor.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        "tglx@linutronix.de" <tglx@linutronix.de>,
        "mingo@redhat.com" <mingo@redhat.com>,
        "gregkh@suse.de" <gregkh@suse.de>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>
Subject: Re: [PATCH v3] x86/mce: Honour bios-set CMCI threshold
References: <CA+8MBbKVa0=qUpG-rjV5ieKkponZo77mzk_y_dF4qA2gVG++6A@mail.gmail.com> <20120912122516.3825.87838.stgit@localhost.localdomain> <505C51D8.6070402@linux.vnet.ibm.com> <20121017105940.GA14590@x1.osrc.amd.com> <507E9622.6090606@linux.vnet.ibm.com> <20121017130934.GB14590@x1.osrc.amd.com> <507ED31B.7010402@linux.vnet.ibm.com> <20121017164006.GA14596@x1.osrc.amd.com> <3908561D78D1C84285E8C5FCA982C28F19D517FF@ORSMSX108.amr.corp.intel.com>
In-Reply-To: <3908561D78D1C84285E8C5FCA982C28F19D517FF@ORSMSX108.amr.corp.intel.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
x-cbid: 12101805-2674-0000-0000-0000066256C8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17/2012 10:58 PM, Luck, Tony wrote:
> BUT (squared) do you even really need to know that thresholds were set? You
> could look at bits {52:38} in the MCi_STATUS information for the bank to see
> how many corrected errors had been logged.

Ah, nice. I think we should be able to use this instead of the sysfs 
attribute.

Thanks,
Naveen

