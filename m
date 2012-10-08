Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753027Ab2JHGlz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 02:41:55 -0400
Received: from cn.fujitsu.com ([222.73.24.84]:16745 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1751060Ab2JHGlw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 02:41:52 -0400
X-IronPort-AV: E=Sophos;i="4.80,551,1344182400"; 
   d="scan'208";a="5959546"
Message-ID: <507276FD.4020808@cn.fujitsu.com>
Date: Mon, 08 Oct 2012 14:47:25 +0800
From: Wen Congyang <wency@cn.fujitsu.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.9) Gecko/20100413 Fedora/3.0.4-2.fc13 Thunderbird/3.0.4
MIME-Version: 1.0
To: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
CC: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Subject: Re: [PATCH 4/4] acpi,memory-hotplug : store the node id in acpi_memory_device
References: <506C0AE8.40702@jp.fujitsu.com> <506C0F53.5030500@jp.fujitsu.com> <CAHGf_=o6K71u4+OVsLvfCSRmOTk12TpsgKwsJO6bGdd_6dYnyA@mail.gmail.com>
In-Reply-To: <CAHGf_=o6K71u4+OVsLvfCSRmOTk12TpsgKwsJO6bGdd_6dYnyA@mail.gmail.com>
X-MIMETrack: Itemize by SMTP Server on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 14:41:44,
	Serialize by Router on mailserver/fnst(Release 8.5.3|September 15, 2011) at
 2012/10/08 14:41:45,
	Serialize complete at 2012/10/08 14:41:45
Content-Transfer-Encoding: 7bit
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

At 10/06/2012 02:56 AM, KOSAKI Motohiro Wrote:
> On Wed, Oct 3, 2012 at 6:11 AM, Yasuaki Ishimatsu
> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>> From: Wen Congyang <wency@cn.fujitsu.com>
>>
>> The memory device has only one node id. Store the node id when
>> enable the memory device, and we can reuse it when removing the
>> memory device.
> 
> You don't explain why we need this. Then nobody can review nor ack.
> 

This patch doesn't fix any problem. Its purpose is: avoid to calculate
the node id twice.

Thanks
Wen Congyang
