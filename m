Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751390Ab2JESyY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Oct 2012 14:54:24 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:52867 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750709Ab2JESyW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Oct 2012 14:54:22 -0400
MIME-Version: 1.0
In-Reply-To: <506C0EC6.9000503@jp.fujitsu.com>
References: <506C0AE8.40702@jp.fujitsu.com> <506C0EC6.9000503@jp.fujitsu.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Fri, 5 Oct 2012 14:54:01 -0400
X-Google-Sender-Auth: 3-RARGyKoV9CIJUu7QMlbXczkh8
Message-ID: <CAHGf_=rCoCs2Lu9gjydTECRydvOkXfbzFGNKJ52CW9oTiOT2Og@mail.gmail.com>
Subject: Re: [PATCH 3/6] acpi,memory-hotplug : add physical memory hotplug
 code to acpi_memhotplug.c
To: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
Cc: x86@kernel.org, linux-mm@kvack.org, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, rientjes@google.com, liuj97@gmail.com,
        len.brown@intel.com, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, wency@cn.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 3, 2012 at 6:09 AM, Yasuaki Ishimatsu
<isimatu.yasuaki@jp.fujitsu.com> wrote:
> From: Yasuaki Ishimatsu <isimatu.yasuaki@jp.fujitsu.com>
>
> For hot removing physical memory, the patch adds remove_memory() into
> acpi_memory_remove_memory(). But we cannot support physical memory
> hot remove. So remove_memory() do nothinig.

I don't understand this explanation. Why do we need do nothing change?
I guess you need to fold this patch into another meaningful fix.
