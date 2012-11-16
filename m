Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753585Ab2KPU0P (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Nov 2012 15:26:15 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35886 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753478Ab2KPU0N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Nov 2012 15:26:13 -0500
User-Agent: K-9 Mail for Android
In-Reply-To: <CAE9FiQUKAhqM-4CRyF2g3VEJ3gA7FEt3ifgA+TvAPRF2Es6vdA@mail.gmail.com>
References: <1353055989-31939-1-git-send-email-yinghai@kernel.org> <1353055989-31939-9-git-send-email-yinghai@kernel.org> <50A6644D.80205@zytor.com> <CAE9FiQXJqyUf7qAspG_ZKUPV96QQjayp8cM0ihQ0RpyU5AxBMA@mail.gmail.com> <50A69664.6070009@zytor.com> <CAE9FiQUJO-HfLs8ddLJ3D_jwpJi_tkxrx19Ro6PNOMGfu4=O-A@mail.gmail.com> <a06b0eea-8d4a-4033-9c74-705b0d72ad83@email.android.com> <CAE9FiQUKAhqM-4CRyF2g3VEJ3gA7FEt3ifgA+TvAPRF2Es6vdA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 8/9] x86: ramdisk info print with high bits.
From: "H. Peter Anvin" <hpa@zytor.com>
Date: Fri, 16 Nov 2012 12:25:47 -0800
To: Yinghai Lu <yinghai@kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        linux-kernel@vger.kernel.org, Matt Fleming <matt.fleming@intel.com>
Message-ID: <1f618403-b89a-49a6-940d-45056f88ad7c@email.android.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

No, it won't... try it.

Yinghai Lu <yinghai@kernel.org> wrote:

>On Fri, Nov 16, 2012 at 12:08 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>> Use %#010llx
>
>that will only print out 0x87654321 when val is 0xa987654321

-- 
Sent from my mobile phone. Please excuse brevity and lack of formatting.
