Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757153Ab0I1SS6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 14:18:58 -0400
Received: from e3.ny.us.ibm.com ([32.97.182.143]:51374 "EHLO e3.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755864Ab0I1SS5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 14:18:57 -0400
Message-ID: <4CA23185.2060905@austin.ibm.com>
Date: Tue, 28 Sep 2010 13:18:45 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.12) Gecko/20100915 Thunderbird/3.0.8
MIME-Version: 1.0
To: Avi Kivity <avi@redhat.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 8/8] v2 Update memory hotplug documentation
References: <4CA0EBEB.1030204@austin.ibm.com> <4CA0F076.1070803@austin.ibm.com> <4CA1E36A.2000005@redhat.com>
In-Reply-To: <4CA1E36A.2000005@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2010 07:45 AM, Avi Kivity wrote:
>  On 09/27/2010 09:28 PM, Nathan Fontenot wrote:
>>
>>   For example, assume 1GiB section size. A device for a memory
>> starting at
>>   0x100000000 is /sys/device/system/memory/memory4
>>   (0x100000000 / 1Gib = 4)
>>   This device covers address range [0x100000000 ... 0x140000000)
>>
>> -Under each section, you can see 4 files.
>> +Under each section, you can see 5 files.
> 
> Shouldn't this be, 4 or 5 files depending on kernel version?
> 

Correct,  I'll update this.  Thanks.

-Nathan
