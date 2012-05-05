Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752515Ab2EEXuH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 19:50:07 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:65478 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752232Ab2EEXuF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 19:50:05 -0400
MIME-Version: 1.0
X-Originating-IP: [173.164.167.193]
In-Reply-To: <1334873552-31346-1-git-send-email-ido@wizery.com>
References: <1333716101-26186-1-git-send-email-ido@wizery.com>
	<1334873552-31346-1-git-send-email-ido@wizery.com>
Date: Sun, 6 May 2012 02:50:04 +0300
Message-ID: <CANtih+8w0wA3ne0-7ewLrvy_WD9cL7sm9jEDR653Hyty3XSLSg@mail.gmail.com>
Subject: Re: [PATCH RESEND] x86: Conditionally update time when ack-ing
 pending irqs
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 1:12 AM, Ido Yariv <ido@wizery.com> wrote:
> From: Shai Fultheim <shai@scalemp.com>
>
> On virtual environments, apic_read could take a long time. As a result,
> under certain conditions the ack pending loop may exit without any
> queued irqs left, but after more than one second. A warning will be
> printed needlessly in this case.
>
> If the loop is about to exit regardless of max_loops, don't update it.
>
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: rebased and reworded the commit message]
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Ping?

Thanks,
Ido.
