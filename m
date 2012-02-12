Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755717Ab2BLRyg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Feb 2012 12:54:36 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:59119 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755672Ab2BLRye convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Feb 2012 12:54:34 -0500
MIME-Version: 1.0
In-Reply-To: <20120212111416.GB21493@elte.hu>
References: <1329016121-26978-1-git-send-email-yinghai@kernel.org>
	<20120212111416.GB21493@elte.hu>
Date: Sun, 12 Feb 2012 09:54:33 -0800
X-Google-Sender-Auth: 9b3HhtKJo5f-rU2LK4Pk2BYV82A
Message-ID: <CAE9FiQXnzGdCqLTSzGt0fjDkCNfx4E=qAgvNf4Xy-pnjaHyZTg@mail.gmail.com>
Subject: Re: [PATCH] x86: Fix show_msr= debug print out
From: Yinghai Lu <yinghai@kernel.org>
To: Ingo Molnar <mingo@elte.hu>
Cc: Thomas Gleixner <tglx@linutronix.de>, "H. Peter Anvin" <hpa@zytor.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 12, 2012 at 3:14 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * Yinghai Lu <yinghai@kernel.org> wrote:
>
>> +void print_cpu_msr(struct cpuinfo_x86 *);
>> +void __cpuinit print_cpu_mdr(struct cpuinfo_x86 *c)
>> +                     print_cpu_msr(&cpu_data(cpu));
>
> This patch cannot possibly have been build tested, let alone
> boot tested.

sorry about that. Just send out tested version (-v3)

Yinghai
