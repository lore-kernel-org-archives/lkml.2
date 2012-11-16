Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab2KPUlD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:41:03 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:43621 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753610Ab2KPUlB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:41:01 -0500
MIME-Version: 1.0
In-Reply-To: <1f618403-b89a-49a6-940d-45056f88ad7c@email.android.com>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org>
	<1353055989-31939-9-git-send-email-yinghai@kernel.org>
	<50A6644D.80205@zytor.com>
	<CAE9FiQXJqyUf7qAspG_ZKUPV96QQjayp8cM0ihQ0RpyU5AxBMA@mail.gmail.com>
	<50A69664.6070009@zytor.com>
	<CAE9FiQUJO-HfLs8ddLJ3D_jwpJi_tkxrx19Ro6PNOMGfu4=O-A@mail.gmail.com>
	<a06b0eea-8d4a-4033-9c74-705b0d72ad83@email.android.com>
	<CAE9FiQUKAhqM-4CRyF2g3VEJ3gA7FEt3ifgA+TvAPRF2Es6vdA@mail.gmail.com>
	<1f618403-b89a-49a6-940d-45056f88ad7c@email.android.com>
Date: Fri, 16 Nov 2012 12:40:59 -0800
X-Google-Sender-Auth: MmsaywUaNhBGH6Z7NMsd9Tbs1lg
Message-ID: <CAE9FiQUdS2YSAwig-3S1VZFzO3SUDWfXJ2KF2A5rxPkHNNiVVA@mail.gmail.com>
Subject: Re: [PATCH 8/9] x86: ramdisk info print with high bits.
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 16, 2012 at 12:25 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> No, it won't... try it.
>

yes, you are right. this patch is not needed.

Thanks

Yinghai
