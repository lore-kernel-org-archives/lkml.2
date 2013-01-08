Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756787Ab3AHR16 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 12:27:58 -0500
Received: from mail-bk0-f54.google.com ([209.85.214.54]:58010 "EHLO
	mail-bk0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756346Ab3AHR14 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 12:27:56 -0500
MIME-Version: 1.0
In-Reply-To: <201301081750.07296.trenn@suse.de>
References: <20121127004144.3604.61708.sendpatchset@tindoh.g01.fujitsu.local>
	<1593084.QhbTkmoq3N@hammer82.arch.suse.de>
	<CAE9FiQWTiFu0+ymVroK84L-LCc7FBU1trdZAcaXqMGM2My6LzQ@mail.gmail.com>
	<201301081750.07296.trenn@suse.de>
Date: Tue, 8 Jan 2013 09:27:55 -0800
X-Google-Sender-Auth: YHHH_6BeSTlhSYbu-za_ECDPG9k
Message-ID: <CAE9FiQXUCtfeKuZVb1=13SL-UUu5hkNE3Q3K8MTZA2ap1qDCAg@mail.gmail.com>
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

On Tue, Jan 8, 2013 at 8:50 AM, Thomas Renninger <trenn@suse.de> wrote:
> megaraid_sas

can you check if your initrd for kdump kernel has that driver and
module that it depends on like
scsi sas transport etc ?

Thanks

Yinghai
