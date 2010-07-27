Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752688Ab0G0UiL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jul 2010 16:38:11 -0400
Received: from out01.mta.xmission.com ([166.70.13.231]:59539 "EHLO
	out01.mta.xmission.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751017Ab0G0UiI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jul 2010 16:38:08 -0400
To: Takao Indoh <indou.takao@jp.fujitsu.com>
Cc: Neil Horman <nhorman@tuxdriver.com>, kexec@lists.infradead.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, mingo@redhat.com,
        hpa@zytor.com, vgoyal@redhat.com
Subject: Re: [PATCH] Enable kdump with EFI boot
References: <C0CB2D0F31868Bindou.takao@jp.fujitsu.com>
	<20100727111029.GA6303@hmsreliant.think-freely.org>
	<m1eieolsy6.fsf@fess.ebiederm.org>
	<C1CB2DC4DB0586indou.takao@jp.fujitsu.com>
From: ebiederm@xmission.com (Eric W. Biederman)
Date: Tue, 27 Jul 2010 13:38:00 -0700
In-Reply-To: <C1CB2DC4DB0586indou.takao@jp.fujitsu.com> (Takao Indoh's message of "Tue\, 27 Jul 2010 15\:49\:42 -0400")
Message-ID: <m1pqy8ek47.fsf@fess.ebiederm.org>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-XM-SPF: eid=;;;mid=;;;hst=in01.mta.xmission.com;;;ip=67.188.4.80;;;frm=ebiederm@xmission.com;;;spf=neutral
X-SA-Exim-Connect-IP: 67.188.4.80
X-SA-Exim-Mail-From: ebiederm@xmission.com
X-SA-Exim-Scanned: No (on in01.mta.xmission.com); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Takao Indoh <indou.takao@jp.fujitsu.com> writes:

> If SetVirtualAddressMap is not called in 1st kernel, EFI system table 
> keeps its physical address, so it's ok, my patch is not needed. Did
> anyone post a patch to do that, or anyone are trying that?

Not that I know of.  What I have heard people doing is not using any
of the kernel efi support at all, in which case everything just works.
Certainly that is what my friends at sgi are doing.

Eric
