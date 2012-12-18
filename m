Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754795Ab2LRXIT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Dec 2012 18:08:19 -0500
Received: from mail-bk0-f49.google.com ([209.85.214.49]:60515 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751367Ab2LRXIR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Dec 2012 18:08:17 -0500
MIME-Version: 1.0
In-Reply-To: <20121218224331.GB4937@liondog.tnic>
References: <1355814959-10573-1-git-send-email-yinghai@kernel.org>
	<20121218224331.GB4937@liondog.tnic>
Date: Tue, 18 Dec 2012 15:08:16 -0800
X-Google-Sender-Auth: mf40oHFlMJzndu8cYb6PTZCyELc
Message-ID: <CAE9FiQUnacMj5f0hs54BDstf1dMQdHxjU_oC7d8g+5+3Bze12w@mail.gmail.com>
Subject: Re: [PATCH v7 00/27] x86, boot, 64bit: Add support for loading
 ramdisk and bzImage above 4G
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 18, 2012 at 2:43 PM, Borislav Petkov <bp@alien8.de> wrote:
> you don't care about properly written commit messages, as long as they work

It seems that you are quite upset somehow.

Writing changelog that everyone could understand seems not be possible for me.
Even I tried harder and splt patches to small pieces.

This patchset is still on going stage, and still need to check with kgdb guys.
I sent v7 out for more broader review, as some or most guys like to
check that in plain-text email instead of git branch.

So don't worry, commit log problem will be addressed.

Thanks

Yinghai
