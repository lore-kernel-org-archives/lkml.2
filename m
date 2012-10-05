Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751623Ab2JES5S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:57:18 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:38510 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab2JES5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:57:16 -0400
MIME-Version: 1.0
In-Reply-To: <506C0F53.5030500@jp.fujitsu.com>
References: <506C0AE8.40702@jp.fujitsu.com> <506C0F53.5030500@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 5 Oct 2012 14:56:55 -0400
X-Google-Sender-Auth: UAACTskNpcnJLv6m0rv2nKJY2vs
Message-ID: <CAHGf_=o6K71u4+OVsLvfCSRmOTk12TpsgKwsJO6bGdd_6dYnyA@mail.gmail.com>
Subject: Re: [PATCH 4/4] acpi,memory-hotplug : store the node id in acpi_memory_device
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, wency@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 6:11 AM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> From: Wen Congyang <wency@cn.fujitsu.com>
>
> The memory device has only one node id. Store the node id when
> enable the memory device, and we can reuse it when removing the
> memory device.

You don't explain why we need this. Then nobody can review nor ack.
