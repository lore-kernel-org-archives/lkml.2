Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755280Ab2D1VdZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Apr 2012 17:33:25 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39001 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752823Ab2D1VdX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Apr 2012 17:33:23 -0400
MIME-Version: 1.0
X-Originating-IP: [79.177.224.247]
In-Reply-To: <1334561976-13965-1-git-send-email-ido@wizery.com>
References: <1333715987-26059-2-git-send-email-ido@wizery.com>
	<1334561976-13965-1-git-send-email-ido@wizery.com>
Date: Sun, 29 Apr 2012 00:33:22 +0300
Message-ID: <CANtih+8zidrJoC4t7YgWW4wU5dj_-WE5xDSprGFVFtpqE4PR5w@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] vsmp: Fix number of CPUs when vsmp is disabled
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Mon, Apr 16, 2012 at 10:39 AM, Ido Yariv <ido@wizery.com> wrote:
> From: Shai Fultheim <shai@scalemp.com>
>
> In case CONFIG_X86_VSMP is not set, limit the number of CPUs to the
> number of CPUs of the first board.
>
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: rebased, fixed minor coding-style issues]
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---
>  arch/x86/kernel/vsmp_64.c |   48 +++++++++++++++++++++++++++++++++++++++++++++
>  1 files changed, 48 insertions(+), 0 deletions(-)

Any thoughts on this set?

Thanks,
Ido.
