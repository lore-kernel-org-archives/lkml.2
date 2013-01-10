Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3AJRFt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 12:05:49 -0500
Received: from mail-bk0-f48.google.com ([209.85.214.48]:53873 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751041Ab3AJRFr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 12:05:47 -0500
MIME-Version: 1.0
In-Reply-To: <20130110121922.GF23008@liondog.tnic>
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
	<1357260531-11115-9-git-send-email-yinghai@kernel.org>
	<20130107155544.GD29449@x1.alien8.de>
	<CAE9FiQXcP9E-RXre_NKf-SU454nT9K39f1GsVVroV1TFxPgQ7g@mail.gmail.com>
	<20130110121922.GF23008@liondog.tnic>
Date: Thu, 10 Jan 2013 09:05:46 -0800
X-Google-Sender-Auth: Aheo9CuelsdvVtiVGpIrCin2r7o
Message-ID: <CAE9FiQV9i2D319soGWyS-NwcEM2HH2gzbh_UjxmoijH0z+0mWQ@mail.gmail.com>
Subject: Re: [PATCH v7u1 08/31] x86, 64bit: early #PF handler set page table
From: Yinghai Lu <yinghai@kernel.org>
To: Borislav Petkov <bp@alien8.de>, Yinghai Lu <yinghai@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 10, 2013 at 4:19 AM, Borislav Petkov <bp@alien8.de> wrote:
> This is not how SOB chaining works:
>
> SOB: Author
> SOB: Handler - this is you, who has added it to the patchset
> SOB: Committer - maintainer
>
> You need to read Documentation/SubmittingPatches if there's still things
> unclear.

Really don't know what you are doing here.

We did that before for a long time.

During reviewing some patches, Linus or HPA or Eric has better idea
and drafted some patch,
without their Signed-offs.

then first version submitter will continue the debugging and testing
and make the patch working.

At last the submit the patch with authorship from Linus or HPA or Eric.

So at that time how can the Signed-off from them?

And there are commits in the upstream does not have Signed-off from the Author.

Thanks

Yinghai
