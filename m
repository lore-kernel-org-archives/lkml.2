Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757530Ab2HVOoz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Aug 2012 10:44:55 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:52436 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756756Ab2HVOox (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Aug 2012 10:44:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/4] ARM: allow PID_IN_CONTEXTIDR only for ARMv7
Date: Wed, 22 Aug 2012 14:44:42 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: Will Deacon <will.deacon@arm.com>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1345645780-2749-1-git-send-email-arnd@arndb.de> <1345645780-2749-3-git-send-email-arnd@arndb.de> <20120822143946.GM9093@mudshark.cambridge.arm.com>
In-Reply-To: <20120822143946.GM9093@mudshark.cambridge.arm.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208221444.42668.arnd@arndb.de>
X-Provags-ID: V02:K0:Qtniq8/5si/FksMnX60utDCW1uOsUw8DbnMDCdNaMtO
 US+mUZKXHTG4AccUQrJl+BoDcdmEUTXk0vBUIiNQOJQGZ8dimK
 YyJNQOKG+Y3p317Naf+bRidT3lJIDFuaiTaMW1u2LXf6eph3OH
 2zVGNR481JoO9UX4eNp/Z+clyySon7S7TxSGUd8qKGfDoxaOBM
 b2EIfCzkV8wCiVeabGT+Ox+HBrxL+qkphVCYNiBsqzvvXRcptO
 rFxS/SnscFYt+PW3VVLPbePFqlRTW3l0UXP3esp3sBLYzRAJD7
 uDlv8GOdjM6LvJ+Iub9mvL4KhKjcYgSK/k6VGsJ4UkxoTa85cq
 HvSCqlIsem2F21gOwfV4=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 22 August 2012, Will Deacon wrote:
> > @@ -398,6 +398,7 @@ config ARM_KPROBES_TEST
> >  config PID_IN_CONTEXTIDR
> >       bool "Write the current PID to the CONTEXTIDR register"
> >       depends on CPU_COPY_V6
> > +     depends on CPU_V7 && !CPU_V6
> >       help
> >         Enabling this option causes the kernel to write the current PID to
> >         the PROCID field of the CONTEXTIDR register, at the expense of some
> 
> Nah, I'll fix the contextidr_notifier instead. I forgot that this stuff gets
> used on non-SMP v6 platforms.
> 

Ok, thanks!

	Arnd
