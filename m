Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934337Ab0EEJhA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 05:37:00 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:46157 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932257Ab0EEJg7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 05:36:59 -0400
MIME-Version: 1.0
In-Reply-To: <20100505085629.GA16278@elte.hu>
References: <1269936436-7039-14-git-send-email-ebiederm@xmission.com>
	 <tip-988856ee1623bd37e384105f7bb2b7fe44c009f6@git.kernel.org>
	 <20100505085629.GA16278@elte.hu>
Date: Wed, 5 May 2010 02:36:58 -0700
Message-ID: <j2taca0ce8b1005050236z8448bb27wacebbb2cf2de0fd4@mail.gmail.com>
Subject: Re: [tip:x86/irq] x86, acpi/irq: Handle isa irqs that are not 
	identity mapped to gsi's.
From: Eric Biederman <ebiederm@aristanetworks.com>
To: Ingo Molnar <mingo@elte.hu>
Cc: mingo@redhat.com, hpa@zytor.com, linux-kernel@vger.kernel.org,
       tglx@linutronix.de, ebiederm@xmission.com,
       Yinghai Lu <yinghai@kernel.org>, linux-tip-commits@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 5, 2010 at 1:56 AM, Ingo Molnar <mingo@elte.hu> wrote:
>
> * tip-bot for Eric W. Biederman <ebiederm@xmission.com> wrote:
>
>> Commit-ID:  988856ee1623bd37e384105f7bb2b7fe44c009f6
>> Gitweb:     http://git.kernel.org/tip/988856ee1623bd37e384105f7bb2b7fe44c009f6
>> Author:     Eric W. Biederman <ebiederm@xmission.com>
>> AuthorDate: Tue, 30 Mar 2010 01:07:15 -0700
>> Committer:  H. Peter Anvin <hpa@zytor.com>
>> CommitDate: Tue, 4 May 2010 13:35:17 -0700
>>
>> x86, acpi/irq: Handle isa irqs that are not identity mapped to gsi's.
>
> FYI, the patchset causes this build error with certain configs:
>
> arch/x86/kernel/acpi/boot.c:122: error: 'gsi_end' undeclared (first use in this function)
> arch/x86/kernel/acpi/boot.c:122: error: (Each undeclared identifier is reported only once
> arch/x86/kernel/acpi/boot.c:122: error: for each function it appears in.)
> arch/x86/kernel/acpi/boot.c:133: error: 'gsi_end' undeclared (first use in this function)

What configuration supports acpi and doesn't support ioapics?

Eric
