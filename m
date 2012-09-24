Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756650Ab2IXPwo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Sep 2012 11:52:44 -0400
Received: from mail.skyhub.de ([78.46.96.112]:43475 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754196Ab2IXPwm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Sep 2012 11:52:42 -0400
Date: Mon, 24 Sep 2012 17:53:01 +0200
From: Borislav Petkov <bp@alien8.de>
To: Nikolay Ulyanitsky <lystor@gmail.com>
Cc: linux-kernel@vger.kernel.org, Mike Galbraith <efault@gmx.de>,
        Andreas Herrmann <andreas.herrmann3@amd.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: 20% performance drop on PostgreSQL 9.2 from kernel 3.5.3 to
 3.6-rc5 on AMD chipsets - bisected
Message-ID: <20120924155259.GB23478@x1.osrc.amd.com>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Nikolay Ulyanitsky <lystor@gmail.com>, linux-kernel@vger.kernel.org,
	Mike Galbraith <efault@gmx.de>,
	Andreas Herrmann <andreas.herrmann3@amd.com>,
	Peter Zijlstra <a.p.zijlstra@chello.nl>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	Thomas Gleixner <tglx@linutronix.de>,
	Ingo Molnar <mingo@kernel.org>
References: <CA+Medix98MHYzpKSDKKWf7Wew0H4zDFsUS74LrhsP2Lxemd3Mw@mail.gmail.com>
 <20120914212717.GA29307@liondog.tnic>
 <CA+55aFwn3UhTDDch4+-=9=T3rHpDvqphY+NLtf2Ljq-7eG+gYw@mail.gmail.com>
 <20120924150048.GB11266@suse.de>
 <CA+MedizYAzdKDkGb0qX5XXTTodgWPuX4=ttCY103UXYLi_0Ocg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CA+MedizYAzdKDkGb0qX5XXTTodgWPuX4=ttCY103UXYLi_0Ocg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 24, 2012 at 06:23:37PM +0300, Nikolay Ulyanitsky wrote:
> On 24 September 2012 18:00, Mel Gorman <mgorman@suse.de> wrote:
> > Reverting Mike's patch might fix this Postgres regression but it reintroduces the overhead caused
> > by commit 4dcfe102 for other cases.
> 
> I just tested pgbench on kernel 3.6-rc7.
> There is no performance regression between 3.5.3 and 3.6-rc7 on AMD X6.

Yes,

what I'm seeing here too. Thanks for testing.

Just one thing, please hit reply-to-all when you reply to the thread so
that everybody can get your mail. I'm readding them for now.

Thanks.

-- 
Regards/Gruss,
Boris.
