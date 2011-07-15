Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755888Ab1GOSPr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Jul 2011 14:15:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44972 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754666Ab1GOSPq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Jul 2011 14:15:46 -0400
Message-ID: <4E20839A.8060200@zytor.com>
Date: Fri, 15 Jul 2011 11:14:50 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.17) Gecko/20110428 Fedora/3.1.10-1.fc15 Thunderbird/3.1.10
MIME-Version: 1.0
To: Mike Waychison <mikew@google.com>
CC: Alan Cox <alan@lxorguk.ukuu.org.uk>, Greg Kroah-Hartman <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        Klibc mailing list <klibc@zytor.com>, Andrew Morgan <agm@google.com>
Subject: Re: [PATCH 2/2] x86: Allow disabling of sys_iopl, sys_ioperm
References: <1310675693-9204-1-git-send-email-mikew@google.com> <1310675693-9204-2-git-send-email-mikew@google.com> <20110714234248.7ed43534@lxorguk.ukuu.org.uk> <CAGTjWtDHH_VXXAsh5WPspTwPEhzcKi4_Jno7w=jReiS7HSALQw@mail.gmail.com> <20110715000037.3fc1670a@lxorguk.ukuu.org.uk> <CAGTjWtA5qobWAZb=SbM1y5SFtDKPuJVuAsbDKmkaxxL7mA6OKg@mail.gmail.com> <20110715003912.149dcedd@lxorguk.ukuu.org.uk> <CAGTjWtD+5cZxQiE+tikUyz2SNgm3bR95GE2veevEv15cPX1E9A@mail.gmail.com> <CAGTjWtAo8dE4ASWYPZ0QJdNg3jFzpO=QP4eT5P3mNakxKy-5+g@mail.gmail.com>
In-Reply-To: <CAGTjWtAo8dE4ASWYPZ0QJdNg3jFzpO=QP4eT5P3mNakxKy-5+g@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/2011 11:13 AM, Mike Waychison wrote:
> 
> So the question is, should this go in the kernel proper such that it
> manipulates the init_cred structure, or should this be plumbed down in
> kinit (in klibc, which we use for bootup)?
> 

It certainly would be trivial to do in kinit.

	-hpa

-- 
H. Peter Anvin, Intel Open Source Technology Center
I work for Intel.  I don't speak on their behalf.

