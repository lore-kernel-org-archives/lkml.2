Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755167Ab2JBR2s (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Oct 2012 13:28:48 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:52337 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab2JBR2p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Oct 2012 13:28:45 -0400
MIME-Version: 1.0
In-Reply-To: <506A36A1.6030709@gmail.com>
References: <1346837155-534-1-git-send-email-wency@cn.fujitsu.com>
 <1346837155-534-7-git-send-email-wency@cn.fujitsu.com> <506A36A1.6030709@gmail.com>
From: KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>
Date: Tue, 2 Oct 2012 13:28:24 -0400
X-Google-Sender-Auth: dA7TDB_RtzCITwyy_HH8sFkm3Sc
Message-ID: <CAHGf_=rX-OHFkBCKzdOi-ydF3VY+Sv_J1osDzZ_MiYEoop145A@mail.gmail.com>
Subject: Re: [RFC v9 PATCH 06/21] memory-hotplug: export the function acpi_bus_remove()
To: Ni zhan Chen <nizhan.chen@gmail.com>
Cc: wency@cn.fujitsu.com, x86@kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-acpi@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-ia64@vger.kernel.org,
        cmetcalf@tilera.com, sparclinux@vger.kernel.org, rientjes@google.com,
        liuj97@gmail.com, len.brown@intel.com, benh@kernel.crashing.org,
        paulus@samba.org, cl@linux.com, minchan.kim@gmail.com,
        akpm@linux-foundation.org, isimatu.yasuaki@jp.fujitsu.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 1, 2012 at 8:34 PM, Ni zhan Chen <nizhan.chen@gmail.com> wrote:
> On 09/05/2012 05:25 PM, wency@cn.fujitsu.com wrote:
>>
>> From: Wen Congyang <wency@cn.fujitsu.com>
>>
>> The function acpi_bus_remove() can remove a acpi device from acpi device.
>
> IIUC, s/acpi device/acpi bus

IIUC, acpi_bus_remove() mean "remove the device from a bus".
