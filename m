Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753879Ab1IFSSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Sep 2011 14:18:13 -0400
Received: from out02.mta.xmission.com ([166.70.13.232]:53379 "EHLO
	out02.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753685Ab1IFSSJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Sep 2011 14:18:09 -0400
From: ebiederm@xmission.com (Eric W. Biederman)
To: Christian Gmeiner <christian.gmeiner@gmail.com>
Cc: linux-kernel@vger.kernel.org
References: <CAH9NwWfGA7jLWDZcN=DfGN5H2g=dt6U8SBxAX_wJAk6MKKfZAA@mail.gmail.com>
Date: Tue, 06 Sep 2011 11:18:05 -0700
In-Reply-To: <CAH9NwWfGA7jLWDZcN=DfGN5H2g=dt6U8SBxAX_wJAk6MKKfZAA@mail.gmail.com>
	(Christian Gmeiner's message of "Mon, 5 Sep 2011 10:24:13 +0200")
Message-ID: <m11uvto7qa.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/23.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=98.207.153.68;;;frm=ebiederm@xmission.com;;;spf=neutral
X-XM-AID: U2FsdGVkX1+FFIJHlXv/e1wf1pyf1nq956PuSZbRSHE=
X-SA-Exim-Connect-IP: 98.207.153.68
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-Spam-Report: * -1.0 ALL_TRUSTED Passed through trusted hosts only via SMTP
	*  0.0 T_TM2_M_HEADER_IN_MSG BODY: T_TM2_M_HEADER_IN_MSG
	* -3.0 BAYES_00 BODY: Bayes spam probability is 0 to 1%
	*      [score: 0.0000]
	* -0.0 DCC_CHECK_NEGATIVE Not listed in DCC
	*      [sa05 1397; Body=1 Fuz1=1 Fuz2=1]
	*  0.4 UNTRUSTED_Relay Comes from a non-trusted relay
X-Spam-DCC: XMission; sa05 1397; Body=1 Fuz1=1 Fuz2=1 
X-Spam-Combo: ;Christian Gmeiner <christian.gmeiner@gmail.com>
X-Spam-Relay-Country: 
Subject: Re: Linux as Bootloader
X-Spam-Flag: No
X-SA-Exim-Version: 4.2.1 (built Fri, 06 Aug 2010 16:31:04 -0600)
X-SA-Exim-Scanned: Yes (on in01.mta.xmission.com)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Christian Gmeiner <christian.gmeiner@gmail.com> writes:

> Hi all,
>
> I am using the linux kernel in combination with busybox and a separate
> bootloader app to
> startup a x86 based embedded device. As the used BIOS does only do
> basic hw init, we
> used Linux as a bootloader. Our custom BIOS starts the bootloader
> kernel located in BIOS
> flash. If the kernel and userland is ready our boot application
> searches for the productive kernel
> and executes it via kexec.
>
> Now I run in some troubles as I need to be able to boot a MSDOS
> application stored on
> an usb stick. I have tried grub4linux but I am not able to boot from
> the usb stick - even I
> see the grub command line.
>
> Are there some creative/working solutions for my problem?

There has been some success using a modified bochs bios on real hardware
in the context of coreboot.  That should be loadable from linux and
usable on your setup.  Avoiding the DOS requirement is probably a more
certain path, getting DOS going is probably more fun.

Eric
