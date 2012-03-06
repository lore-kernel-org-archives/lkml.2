Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab2CFG1e (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Mar 2012 01:27:34 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:45194 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751641Ab2CFG1c convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Mar 2012 01:27:32 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of yhlu.kernel@gmail.com designates 10.236.116.66 as permitted sender) smtp.mail=yhlu.kernel@gmail.com; dkim=pass header.i=yhlu.kernel@gmail.com
MIME-Version: 1.0
In-Reply-To: <4F556D3D.8040400@zytor.com>
References: <1330669703-20176-1-git-send-email-zhenzhong.duan@oracle.com>
	<CAE9FiQV3CyB1YRPDxFu-jGr73+Qwpkn4O4QYYZvBJcyZA5Gouw@mail.gmail.com>
	<4F556D3D.8040400@zytor.com>
Date: Mon, 5 Mar 2012 22:27:32 -0800
X-Google-Sender-Auth: TlueJnJ3FhfabjL8UFSoc86PX2k
Message-ID: <CAE9FiQVU8fafCEZrRPADMYubvncxT+0FGdWVPuu0M=O8NYaCYw@mail.gmail.com>
Subject: Re: [PATCH] Initialize max_pfn_mapped as initial ident mapping size
 for x86_64
From: Yinghai Lu <yinghai@kernel.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: zhenzhong.duan@oracle.com, Takashi Iwai <tiwai@suse.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        joe.jin@oracle.com, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 5:49 PM, H. Peter Anvin <hpa@zytor.com> wrote:
>
> WHY does it have a problem with S4 resume?  S4 is Linux code, so there
> is a bug here that people keep trying to hack around instead of digging
> into.

it seems that problem only happen with Suse userland application etc.

Takashi, can you detail the steps so we can duplicate the problem ?

>
> The early mapping range we can fix, and probably should.  Mapping the
> first 4 GiB is not a lot of memory and makes a much more sensible
> starting point.

do you mean map the 4G in head_64.S?

Yinghai
