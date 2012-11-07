Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753838Ab2KGSUY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Nov 2012 13:20:24 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:61870 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752342Ab2KGSUW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Nov 2012 13:20:22 -0500
MIME-Version: 1.0
In-Reply-To: <509A044D.30100@jp.fujitsu.com>
References: <20121015065516.2832.42378.sendpatchset@indoh>
	<20121015065526.2832.90867.sendpatchset@indoh>
	<CAE9FiQXKjNU4Sasj4LmiFiNNu9quGgKAdW3ciVnXggoWZiYXJA@mail.gmail.com>
	<507CE14A.2020605@jp.fujitsu.com>
	<509A044D.30100@jp.fujitsu.com>
Date: Wed, 7 Nov 2012 10:20:20 -0800
X-Google-Sender-Auth: dT1eQ3nU9EooiSqkqtC7vSOsc_A
Message-ID: <CAE9FiQWOfownBsSsw-36Ti-hHeKuVaq8Y5eaMHMHpLK4NXhC0g@mail.gmail.com>
Subject: Re: [PATCH v4 1/2] x86, pci: Reset PCIe devices at boot time
From: Yinghai Lu <yinghai@kernel.org>
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: martin.wilck@ts.fujitsu.com, linux-pci@vger.kernel.org, x86@kernel.org,
        kexec@lists.infradead.org, linux-kernel@vger.kernel.org,
        hbabu@us.ibm.com, andi@firstfloor.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, hpa@zytor.com, bhelgaas@google.com,
        tglx@linutronix.de, mingo@redhat.com, vgoyal@redhat.com,
        khalid@gonehiking.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 6, 2012 at 10:48 PM, Takao Indoh <indou.takao@jp.fujitsu.com> wrote:
> I'm rewriting my reset code using your dummy pci_dev patch. Do you have
> a plan to post it or can I post it with my patches?

Yes, you can post it with your patches if you like.

Yinghai
