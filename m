Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758762Ab2EIIlM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 04:41:12 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:43633 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754330Ab2EIIlJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 04:41:09 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <20120507215828.GA21748@codeaurora.org>
References: <20120507215828.GA21748@codeaurora.org>
Date: Wed, 9 May 2012 01:41:08 -0700
Message-ID: <CAOesGMgMTOSzzystxyaTNVFX6=z6ijsSThYrVx1XnARyLxrTeA@mail.gmail.com>
Subject: Re: [GIT PULL] msm-core changes for v3.5.
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

Hi,

On Mon, May 7, 2012 at 2:58 PM, David Brown <davidb@codeaurora.org> wrote:
> These are some minor fixes, and Daniel's fixup of the sapphire target
> support.
>
> The following changes since commit 0034102808e0dbbf3a2394b82b1bb40b5778de9e:
>
>  Linux 3.4-rc2 (2012-04-07 18:30:41 -0700)
>
> are available in the git repository at:
>
>  git://git.kernel.org/pub/scm/linux/kernel/git/davidb/linux-msm.git msm-core
>
> for you to fetch changes up to 2935b1facdfb77d5f03d9036cc0da8c889f59a02:
>
>  ARM: msm: fix compilation flags for MSM_SCM (part 2) (2012-05-01 16:44:11 -0700)
>
> ----------------------------------------------------------------
> Daniel Walker (1):
>      arm: msm: fix up very basic HTC Sapphire support

See separate email on comments for the sapphire patch, I'll hold off
pulling this until that's revisited.


Thanks,


-Olof
