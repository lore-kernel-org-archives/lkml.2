Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2DYSJd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Apr 2012 14:09:33 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:37294 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753096Ab2DYSJc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Apr 2012 14:09:32 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20120424175457.GA5013@codeaurora.org>
References: <20120424175457.GA5013@codeaurora.org>
Date: Wed, 25 Apr 2012 11:09:31 -0700
Message-ID: <CAOesGMjHigkcY-bEjO7PKc0T-C_6HVMiRydgJjzV+agVLQKU1Q@mail.gmail.com>
Subject: Re: [GIT PULL] msm fixes for 3.4rc
From: Olof Johansson <olof@lixom.net>
To: David Brown <davidb@codeaurora.org>
Cc: arm@kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Russell King <rmk@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 24, 2012 at 10:54 AM, David Brown <davidb@codeaurora.org> wrote:
> This fixes a boot problem with the MSM8660 target on device tree
> caused by the conversion of the ARM GIC driver to proper IRQ domain
> support.
>
> The following changes since commit af33eadc73e4a5d35a966c1c7ffe28a8424c9d96:
>
>  ARM: msm: Fix section mismatches in proc_comm.c (2012-04-13 10:23:17 -0700)
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git msm-fix

Thanks, pulled.


-Olof
