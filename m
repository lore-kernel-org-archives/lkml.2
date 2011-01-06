Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753478Ab1AFS4f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 13:56:35 -0500
Received: from smtp1.linux-foundation.org ([140.211.169.13]:56245 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab1AFS4e convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 13:56:34 -0500
MIME-Version: 1.0
In-Reply-To: <20110106094423.GA17565@elte.hu>
References: <20110106094423.GA17565@elte.hu>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Thu, 6 Jan 2011 10:55:43 -0800
Message-ID: <AANLkTinU423YzQxB9y7ZM9GQAYPQyTJUm9w18=6P_F88@mail.gmail.com>
Subject: Re: [GIT PULL] x86/apic changes for v2.6.38
To: Ingo Molnar <mingo@elte.hu>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Wu Fengguang <fengguang.wu@intel.com>,
        Bjorn Helgaas <bjorn.helgaas@hp.com>, Yinghai Lu <yinghai@kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 6, 2011 at 1:44 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> out-of-topic modifications in x86-apic-for-linus:
> -------------------------------------------------
> drivers/acpi/numa.c                # d3bd058: x86, acpi: Parse all SRAT cpu ent

Why is this x86-only? Aren't the same issues possible elsewhere?

Sure, ACPI is only used on x86 and ia64, and likely nobody cares about
ia64, but that CONFIG_X86 still looks odd.

                      Linus
