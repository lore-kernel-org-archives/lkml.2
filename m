Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760124Ab2JLTAU (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 15:00:20 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:45285 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754095Ab2JLTAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 15:00:17 -0400
MIME-Version: 1.0
In-Reply-To: <507276FD.4020808@cn.fujitsu.com>
References: <506C0AE8.40702@jp.fujitsu.com> <506C0F53.5030500@jp.fujitsu.com>
 <CAHGf_=o6K71u4+OVsLvfCSRmOTk12TpsgKwsJO6bGdd_6dYnyA@mail.gmail.com> <507276FD.4020808@cn.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 12 Oct 2012 14:59:56 -0400
X-Google-Sender-Auth: yj1uK9Vh9EIWaqvnuqwOq_2rDl8
Message-ID: <CAHGf_=rf+ginaNjYifJJVa6sy2Hd41tdJQtC_JtmGaneyKqbkA@mail.gmail.com>
Subject: Re: [PATCH 4/4] acpi,memory-hotplug : store the node id in acpi_memory_device
To: Wen Congyang <wency@cn.fujitsu.com>
Cc: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>, x86@kernel.org,
        linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 8, 2012 at 2:47 AM, Wen Congyang <wency@cn.fujitsu.com> wrote:
> At 10/06/2012 02:56 AM, KOSAKI Motohiro Wrote:
>> On Wed, Oct 3, 2012 at 6:11 AM, Yasuaki Ishimatsu
>> <isimatu.yasuaki@jp.fujitsu.com> wrote:
>>> From: Wen Congyang <wency@cn.fujitsu.com>
>>>
>>> The memory device has only one node id. Store the node id when
>>> enable the memory device, and we can reuse it when removing the
>>> memory device.
>>
>> You don't explain why we need this. Then nobody can review nor ack.
>>
>
> This patch doesn't fix any problem. Its purpose is: avoid to calculate
> the node id twice.

ditto.

Please separate patches as logical change. You should make problem fix
patch set.
