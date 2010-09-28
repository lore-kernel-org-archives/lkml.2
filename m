Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754306Ab0I1Mpx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Sep 2010 08:45:53 -0400
Received: from mx1.redhat.com ([209.132.183.28]:54216 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754039Ab0I1Mpw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Sep 2010 08:45:52 -0400
Message-ID: <4CA1E36A.2000005@redhat.com>
Date: Tue, 28 Sep 2010 14:45:30 +0200
From: Avi Kivity <avi@redhat.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.9) Gecko/20100921 Fedora/3.1.4-1.fc13 Lightning/1.0b3pre Thunderbird/3.1.4
MIME-Version: 1.0
To: Nathan Fontenot <nfont@austin.ibm.com>
CC: linux-kernel@vger.kernel.org, linux-mm@kvack.org, linuxppc-dev@ozlabs.org,
        Greg KH <greg@kroah.com>, Dave Hansen <dave@linux.vnet.ibm.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>
Subject: Re: [PATCH 8/8] v2 Update memory hotplug documentation
References: <4CA0EBEB.1030204@austin.ibm.com> <4CA0F076.1070803@austin.ibm.com>
In-Reply-To: <4CA0F076.1070803@austin.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  On 09/27/2010 09:28 PM, Nathan Fontenot wrote:
>
>   For example, assume 1GiB section size. A device for a memory starting at
>   0x100000000 is /sys/device/system/memory/memory4
>   (0x100000000 / 1Gib = 4)
>   This device covers address range [0x100000000 ... 0x140000000)
>
> -Under each section, you can see 4 files.
> +Under each section, you can see 5 files.

Shouldn't this be, 4 or 5 files depending on kernel version?

-- 
error compiling committee.c: too many arguments to function

