Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752454Ab2EEXtM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 May 2012 19:49:12 -0400
Received: from mail-ob0-f174.google.com ([209.85.214.174]:53739 "EHLO
	mail-ob0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752227Ab2EEXtK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 May 2012 19:49:10 -0400
MIME-Version: 1.0
X-Originating-IP: [173.164.167.193]
In-Reply-To: <1334873492-31255-1-git-send-email-ido@wizery.com>
References: <1333716049-26122-1-git-send-email-ido@wizery.com>
	<1334873492-31255-1-git-send-email-ido@wizery.com>
Date: Sun, 6 May 2012 02:49:10 +0300
Message-ID: <CANtih+9byBuPQpsdRnAh3e8xH1QDz_8SxAC7sSv=-hSdaFQL8Q@mail.gmail.com>
Subject: Re: [PATCH RESEND] x86: Avoid contention on cpa_lock if possible
From: Ido Yariv <ido@wizery.com>
To: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>
Cc: Shai Fultheim <shai@scalemp.com>, Ido Yariv <ido@wizery.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 20, 2012 at 1:11 AM, Ido Yariv <ido@wizery.com> wrote:
> From: Shai Fultheim <shai@scalemp.com>
>
> Some architectures (e.g. vSMP) do not require to serialize cpa, for
> instance, by guaranteeing that the most recent TLB entry will always be
> used.
>
> To avoid needless contention on cpa_lock, do not lock/unlock it on such
> architectures.
>
> Signed-off-by: Shai Fultheim <shai@scalemp.com>
> [ido@wizery.com: added should_serialize_cpa, handled potential race, and
>                 reworded the commit message]
> Signed-off-by: Ido Yariv <ido@wizery.com>
> ---

Ping?
