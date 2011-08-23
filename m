Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755704Ab1HWTFa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Aug 2011 15:05:30 -0400
Received: from mail-vx0-f174.google.com ([209.85.220.174]:58700 "EHLO
	mail-vx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755665Ab1HWTFV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Aug 2011 15:05:21 -0400
MIME-Version: 1.0
In-Reply-To: <tip-4822b7fc6d4870685a9feadfc348d48f5e47460a@git.kernel.org>
References: <4D5DFBE4.7090104@intel.com>
	<tip-4822b7fc6d4870685a9feadfc348d48f5e47460a@git.kernel.org>
Date: Tue, 23 Aug 2011 12:05:20 -0700
X-Google-Sender-Auth: nvtAsRBOfkUNs8m9iM2yipfrMys
Message-ID: <CA+8MBbLA0bDrJjCUoFBZRnA3+mLwKG+gZnXVt30Rwvza+Tj=Og@mail.gmail.com>
Subject: Re: [tip:x86/trampoline] x86, trampoline: Common infrastructure for
 low memory trampolines
From: Tony Luck <tony.luck@intel.com>
To: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
        castet.matthieu@free.fr, tglx@linutronix.de, sfr@canb.auug.org.au,
        hpa@linux.intel.com, rjw@sisk.pl
Cc: linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Feb 17, 2011 at 9:19 PM, tip-bot for H. Peter Anvin
<hpa@linux.intel.com> wrote:
> +       printk(KERN_DEBUG "smpboot cpu %d: start_ip = %lx\n", cpu, start_ip);
> +

This is kind of noisy on a large system:

Booting Node   0, Processors  #1
smpboot cpu 1: start_ip = 96000
 #2
smpboot cpu 2: start_ip = 96000
 #3
smpboot cpu 3: start_ip = 96000
 #4
smpboot cpu 4: start_ip = 96000
 #5
smpboot cpu 5: start_ip = 96000
  ... continues for every cpu ...

and doesn't really look all that useful. Can we drop it?

-Tony
