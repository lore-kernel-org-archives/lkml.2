Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752479Ab2EEXqb (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 19:46:31 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:39177 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752331Ab2EEXqa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 19:46:30 -0400
MIME-Version: 1.0
X-Originating-IP: [173.164.167.193]
In-Reply-To: <1334873351-31142-1-git-send-email-ido@wizery.com>
References: <1333715894-25995-1-git-send-email-ido@wizery.com>
	<1334873351-31142-1-git-send-email-ido@wizery.com>
Date: Sun, 6 May 2012 02:46:29 +0300
Message-ID: <CANtih+_tBk6AOdkVmNrODsV8tSDPt_FW98cGcF0xsb+=7xZLUA@mail.gmail.com>
Subject: Re: [PATCH RESEND] x86: cache_info: Fix setup of l2/l3 ids
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 1:09 AM, Ido Yariv <ido@wizery.com> wrote:
> From: Shai Fultheim <shai@scalemp.com>
>
> On some architectures (such as vSMP), it is possible to have CPUs with a
> different number of cores sharing the same cache.
>
> The current implementation implicitly assumes that all CPUs will have
> the same number of cores sharing caches, and as a result, different CPUs
> can end up with the same l2/l3 ids.
>
> Fix this by masking out the shared cache bits, instead of shifting the
> APICID. By doing so, it is guaranteed that the generated cache ids are
> always unique.
>
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: rebased, simplified, and reworded the commit message]
> Signed-off-by: Ido Yariv <ido@wizery.com>

Ping?
