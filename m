Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753187Ab2KLOAW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Nov 2012 09:00:22 -0500
Received: from moutng.kundenserver.de ([212.227.17.9]:58520 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751628Ab2KLOAU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Nov 2012 09:00:20 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Vineet.Gupta1@synopsys.com
Subject: Re: [RFC Patch v1 45/55] ARC: unaligned access emulation
Date: Mon, 12 Nov 2012 14:00:12 +0000
User-Agent: KMail/1.12.2 (Linux/3.5.0; KDE/4.3.2; x86_64; ; )
Cc: linux-arch@vger.kernel.org, linux-kernel@vger.kernel.org,
        tglx@linutronix.de
References: <1352720953-24321-1-git-send-email-vgupta@synopsys.com> <1352720953-24321-15-git-send-email-vgupta@synopsys.com>
In-Reply-To: <1352720953-24321-15-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201211121400.13046.arnd@arndb.de>
X-Provags-ID: V02:K0:Fd4EnFF9XmZrni5HLrUELQr3/UaO0GV2pl9KxAruf51
 qYr9Zlqx49MfCY0nniascfLjmVN15LCLfGShVvqJuwm90AxwaH
 Z4VVQT02Nj79o4VsHFq0XHTBXEzJkuf0ZD4qw4AcEEyQFCN2kL
 3dsMOzC1qKcu0fy8d5JLh57ZDsWh4oDnZgpgazjFJN+RQF2H9m
 t18iTD/B0HP0jznXJ34vHEoOSDqfh7LsMsqIcw+Y/u71oL50H4
 ZyQSCh08AfltbbczWWFfm/RvBH6UZ3Moc5sfiFsJxWOUArWJa3
 KNef1OAA8m7Ha+svSpmpSjhDdfEspGjZXp2fx3zOAZQuvXa0sF
 aSqqgG5sg3H87Dq1P/rE=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 12 November 2012, Vineet.Gupta1@synopsys.com wrote:
> +
> +config ARC_MISALIGN_ACCESS
> +       bool "Emulate unaligned memory access (userspace only)"
> +       default N
> +       help
> +         This enables misaligned 16 & 32 bit memory access from user space.
> +         Use ONLY-IF-ABS-NECESSARY as it will be very slow and also can hide
> +         potential bugs in code

parisc and ia64 both have the same feature, and they use sysctl to configure
it at run-time. Maybe you should pick one of the two sysctl implementations
and hook that up to your implementation as well.

	Arnd
