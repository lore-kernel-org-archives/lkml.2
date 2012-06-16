Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756757Ab2FPTgJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Jun 2012 15:36:09 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:34512 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756021Ab2FPTgI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Jun 2012 15:36:08 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.LFD.2.02.1206161048010.3086@ionos>
References: <CAOPLpQfUm-2ENkbnYfXEn1nf9FHnaRk3aqQTSTBWb-CsfCUCFA@mail.gmail.com>
	<CAE9FiQU=Uvj_OFYQLdddf8j59vE7D0aE9cdNZv7P8_Rn7=MmUQ@mail.gmail.com>
	<alpine.LFD.2.02.1206161048010.3086@ionos>
Date: Sat, 16 Jun 2012 12:36:06 -0700
X-Google-Sender-Auth: qhh2iV1mUBwmTiJIrDMnDj3wtGk
Message-ID: <CAE9FiQU-Ev1goCqA9LfBJL6T4WTkazJMExPTtz71H44aZrSVnA@mail.gmail.com>
Subject: Re: SNB PCI root information
From: Yinghai Lu <yinghai@kernel.org>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Ulrich Drepper <drepper@gmail.com>, Bjorn Helgaas <bhelgaas@google.com>,
        jbarnes@virtuousgeek.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        lenb@kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 16, 2012 at 1:52 AM, Thomas Gleixner <tglx@linutronix.de> wrote:
>> I have one local internal similar patch for SNB iio for crossing check
>> if BIOS set correctly.
>> but I don't think i will try to get blessing from intel to publish it.
>
> Why do you need Intels blessing to post a useful patch?
>
> Is that patch based on public available documentation and/or your own
> findings?
>
> If yes, then hell we don't care whether Intel likes it or not.
>
> If not, then the question arises what Intel has to hide in that area.

it is with Intel NDA EDS or BIOS writing guide.

Thanks

Yinghai
