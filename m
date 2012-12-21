Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752485Ab2LUQTT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Dec 2012 11:19:19 -0500
Received: from mail-bk0-f45.google.com ([209.85.214.45]:61903 "EHLO
	mail-bk0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751582Ab2LUQTH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Dec 2012 11:19:07 -0500
MIME-Version: 1.0
In-Reply-To: <50B8D571.3000000@jp.fujitsu.com>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<50B8D571.3000000@jp.fujitsu.com>
Date: Fri, 21 Dec 2012 08:19:05 -0800
X-Google-Sender-Auth: gvOSC3jpyUQhKGhleZCFQz03Mf0
Message-ID: <CAE9FiQVaqXMfju5j7qBsk+g=RpES-adBBdrDcnkW=YQTQOfugQ@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump
 with iommu
From: Yinghai Lu <yinghai@kernel.org>
To: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Thomas Renninger <trenn@suse.de>
Cc: Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 30, 2012 at 7:49 AM, MUNEDA Takahiro
<muneda.takahiro@jp.fujitsu.com> wrote:
> On Tue, 27 Nov 2012 09:42:20 +0900 (JST),
> Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
>
>> These patches reset PCIe devices at boot time to address DMA problem on
>> kdump with iommu. When "reset_devices" is specified, a hot reset is
>> triggered on each PCIe root port and downstream port to reset its
>> downstream endpoint.

ThomasR, Can you check if this one help your test case about interrupt ?

Yinghai
