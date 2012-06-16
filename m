Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755922Ab2FPIw7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 04:52:59 -0400
Received: from www.linutronix.de ([62.245.132.108]:43821 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751208Ab2FPIw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 04:52:56 -0400
Date: Sat, 16 Jun 2012 10:52:51 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: Yinghai Lu <yinghai@kernel.org>
cc: Ulrich Drepper <drepper@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Subject: Re: SNB PCI root information
In-Reply-To: <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.02.1206161048010.3086@ionos>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com> <CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Jun 2012, Yinghai Lu wrote:
> We used to have same for intel IOH nehalem,  and get bless from intel.
> but that get removed at some point.

Why so?

> I have one local internal similar patch for SNB iio for crossing check
> if BIOS set correctly.
> but I don't think i will try to get blessing from intel to publish it.

Why do you need Intels blessing to post a useful patch?

Is that patch based on public available documentation and/or your own
findings?

If yes, then hell we don't care whether Intel likes it or not.

If not, then the question arises what Intel has to hide in that area.

Thanks,

	tglx
