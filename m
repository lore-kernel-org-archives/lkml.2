Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752408Ab2ELFb7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 12 May 2012 01:31:59 -0400
Received: from mail-yw0-f46.google.com ([209.85.213.46]:38240 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272Ab2ELFb5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 12 May 2012 01:31:57 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20120511183216.GA13034@codeaurora.org>
References: <20120507215828.GA21748@codeaurora.org>
	<20120511183216.GA13034@codeaurora.org>
Date: Fri, 11 May 2012 22:31:56 -0700
Message-ID: <CAOesGMhLbsmqxeMKnLQ9bafj3SxfDChyCwODguNTmo6Z92ozHw@mail.gmail.com>
Subject: Re: [GIT PULL] msm-core changes for v3.5, take 2
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

On Fri, May 11, 2012 at 11:32 AM, David Brown <davidb@codeaurora.org> wrote:
> Some minor fixes to msm.  Dropped Sapphire support from Daniel Walker
> until concerns are addressed.
>
> The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:
>
>  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git msm-core

Thanks, pulled into next/cleanup, since the three patches seemed to
mostly match that topic.


-Olof
