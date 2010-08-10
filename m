Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932097Ab0HJMRl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Aug 2010 08:17:41 -0400
Received: from e8.ny.us.ibm.com ([32.97.182.138]:34209 "EHLO e8.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757571Ab0HJMRf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Aug 2010 08:17:35 -0400
Message-ID: <4C61434F.7060808@austin.ibm.com>
Date: Tue, 10 Aug 2010 07:17:19 -0500
From: Nathan Fontenot <nfont@austin.ibm.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.11) Gecko/20100713 Thunderbird/3.0.6
MIME-Version: 1.0
To: Nishanth Aravamudan <nacc@us.ibm.com>
CC: linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, linuxppc-dev@ozlabs.org, Greg KH <greg@kroah.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        Dave Hansen <dave@linux.vnet.ibm.com>
Subject: Re: [PATCH 8/8] v5  Update memory-hotplug documentation
References: <4C60407C.2080608@austin.ibm.com> <4C604C62.7060509@austin.ibm.com> <201008091344.37878.nacc@us.ibm.com>
In-Reply-To: <201008091344.37878.nacc@us.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/09/2010 03:44 PM, Nishanth Aravamudan wrote:
> On Monday, August 09, 2010 11:43:46 am Nathan Fontenot wrote:
>> Update the memory hotplug documentation to reflect the new behaviors of
>> memory blocks reflected in sysfs.
> 
> <snip>
> 
>> Index: linux-2.6/Documentation/memory-hotplug.txt
>> ===================================================================
>> --- linux-2.6.orig/Documentation/memory-hotplug.txt	2010-08-09 07:36:48.000000000 -0500
>> +++ linux-2.6/Documentation/memory-hotplug.txt	2010-08-09 07:59:54.000000000 -0500
> 
> <snip>
> 
>> -/sys/devices/system/memory/memoryXXX/phys_index
>> +/sys/devices/system/memory/memoryXXX/start_phys_index
>> +/sys/devices/system/memory/memoryXXX/end_phys_index
>>  /sys/devices/system/memory/memoryXXX/phys_device
>>  /sys/devices/system/memory/memoryXXX/state
>>  /sys/devices/system/memory/memoryXXX/removable
>>
>> -'phys_index' : read-only and contains section id, same as XXX.
> 
> <snip>
> 
>> +'phys_index'      : read-only and contains section id of the first section
> 
> Shouldn't this be "start_phys_index"?

Hmmm... looks like  I missed something in the documentation.

The property should be 'phys_index'.  I thought about changing it to
'start_phys_index' but that was rejected.  The listing of the files
above is wrong in this patch, it should be 

 +/sys/devices/system/memory/memoryXXX/phys_index
 +/sys/devices/system/memory/memoryXXX/end_phys_index

Thanks, 

Nathan
