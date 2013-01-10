Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754583Ab3AJMT3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 07:19:29 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33495 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754348Ab3AJMTZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 07:19:25 -0500
Date: Thu, 10 Jan 2013 13:19:22 +0100
From: Borislav Petkov <bp@alien8.de>
To: Yinghai Lu <yinghai@kernel.org>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jan Kiszka <jan.kiszka@web.de>,
        Jason Wessel <jason.wessel@windriver.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v7u1 08/31] x86, 64bit: early #PF handler set page table
Message-ID: <20130110121922.GF23008@liondog.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Yinghai Lu <yinghai@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
	"H. Peter Anvin" <hpa@zytor.com>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Jan Kiszka <jan.kiszka@web.de>,
	Jason Wessel <jason.wessel@windriver.com>,
	linux-kernel@vger.kernel.org
References: <1357260531-11115-1-git-send-email-yinghai@kernel.org>
 <1357260531-11115-9-git-send-email-yinghai@kernel.org>
 <20130107155544.GD29449@x1.alien8.de>
 <CAE9FiQXcP9E-RXre_NKf-SU454nT9K39f1GsVVroV1TFxPgQ7g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAE9FiQXcP9E-RXre_NKf-SU454nT9K39f1GsVVroV1TFxPgQ7g@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jan 09, 2013 at 05:56:07PM -0800, Yinghai Lu wrote:
> On Mon, Jan 7, 2013 at 7:55 AM, Borislav Petkov <bp@alien8.de> wrote:
> > Those -vXX version lines need to go under the "---" line. Alternatively,
> > you might want to add some of them to the commit message with a proper
> > explanation since they are not that trivial at a first glance, for
> > example the -v5, -v6, -v8, -v9 with a better explanation.
> 
> mostly they are for tracking version.

I know that! Please read my suggestion again.

> > This needs hpa's S-O-B.
> 
> he will add later when he put the in the tip.

This is not how SOB chaining works:

SOB: Author
SOB: Handler - this is you, who has added it to the patchset
SOB: Committer - maintainer

You need to read Documentation/SubmittingPatches if there's still things
unclear.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
