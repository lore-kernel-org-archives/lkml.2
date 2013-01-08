Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754036Ab3AHDE7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Jan 2013 22:04:59 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:59682 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753327Ab3AHDE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Jan 2013 22:04:58 -0500
MIME-Version: 1.0
In-Reply-To: <3649945.08HKjS0y0c@hammer82.arch.suse.de>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<1593084.QhbTkmoq3N@hammer82.arch.suse.de>
	<CAE9FiQWTiFu0+ymVroK84L-LCc7FBU1trdZAcaXqMGM2My6LzQ@mail.gmail.com>
	<3649945.08HKjS0y0c@hammer82.arch.suse.de>
Date: Mon, 7 Jan 2013 19:04:56 -0800
X-Google-Sender-Auth: aTbu3TSPnS0PtIBlBnaBWgO_4lE
Message-ID: <CAE9FiQUueTB6gc5uMUApqeS7FtzMESLLFEt3ZuOMJgXsnjFQ0A@mail.gmail.com>
Subject: Re: [PATCH v7 0/5] Reset PCIe devices to address DMA problem on kdump
 with iommu
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Renninger <trenn@suse.de>
Cc: MUNEDA Takahiro <muneda.takahiro@jp.fujitsu.com>,
        Takao Indoh <indou.takao@jp.fujitsu.com>, linux-pci@vger.kernel.org,
        x86@kernel.org, linux-kernel@vger.kernel.org, andi@firstfloor.org,
        tokunaga.keiich@jp.fujitsu.com, kexec@lists.infradead.org,
        hbabu@us.ibm.com, mingo@redhat.com, ddutile@redhat.com,
        vgoyal@redhat.com, ishii.hironobu@jp.fujitsu.com, hpa@zytor.com,
        bhelgaas@google.com, tglx@linutronix.de, khalid@gonehiking.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 7, 2013 at 4:42 PM, Thomas Renninger <trenn@suse.de> wrote:
> memmap=256M$3584M

may need to change to:

memmap=256M\$\$3584M

Thanks

Yinghai
