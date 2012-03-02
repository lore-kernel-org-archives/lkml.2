Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965278Ab2CBBs4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Mar 2012 20:48:56 -0500
Received: from mail-tul01m020-f174.google.com ([209.85.214.174]:40183 "EHLO
	mail-tul01m020-f174.google.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753475Ab2CBBsx convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Mar 2012 20:48:53 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of amluto@gmail.com designates 10.182.1.4 as permitted sender) smtp.mail=amluto@gmail.com; dkim=pass header.i=amluto@gmail.com
MIME-Version: 1.0
In-Reply-To: <CAGXu5jL0OXR5MOePFe=GT4_X5rdH8RNjQPqYXdbqsqfijUsEqA@mail.gmail.com>
References: <1330559620-23543-1-git-send-email-wad@chromium.org>
 <20120301233712.GS3990@outflux.net> <20120302114705.0a9542e138927897f16282ca@canb.auug.org.au>
 <CAGXu5jL0OXR5MOePFe=GT4_X5rdH8RNjQPqYXdbqsqfijUsEqA@mail.gmail.com>
From: Andrew Lutomirski <luto@mit.edu>
Date: Thu, 1 Mar 2012 17:48:32 -0800
X-Google-Sender-Auth: ycBRu7Qsdy56CjmuhvPnD3PsLKo
Message-ID: <CAObL_7H5i_oU2NORmV4TC3X2p3kUeN_ekBcd7PTDf0MuGOuGcQ@mail.gmail.com>
Subject: Re: [PATCH v12 01/13] sk_run_filter: add support for custom load_pointer
To: Kees Cook <keescook@chromium.org>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, akpm@linux-foundation.org,
        Will Drewry <wad@chromium.org>, linux-kernel@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-doc@vger.kernel.org,
        kernel-hardening@lists.openwall.com, netdev@vger.kernel.org,
        x86@kernel.org, arnd@arndb.de, davem@davemloft.net, hpa@zytor.com,
        mingo@redhat.com, oleg@redhat.com, peterz@infradead.org,
        rdunlap@xenotime.net, mcgrathr@chromium.org, tglx@linutronix.de,
        eparis@redhat.com, serge.hallyn@canonical.com, djm@mindrot.org,
        scarybeasts@gmail.com, indan@nul.nu, pmoore@redhat.com, corbet@lwn.net,
        eric.dumazet@gmail.com, markus@chromium.org, coreyb@linux.vnet.ibm.com
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 1, 2012 at 4:57 PM, Kees Cook <keescook@chromium.org> wrote:
> Hi,
>
> On Thu, Mar 1, 2012 at 4:47 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>> Hi Kees,
>>
>> On Thu, 1 Mar 2012 15:37:12 -0800 Kees Cook <keescook@chromium.org> wrote:
>>>
>>> Is it time to pull this into -next so more people can feel it? I brought
>>> Andy Lutomirski's patches forward (needed to bump the prctl values), and
>>> updated my git tree. If we're ready, here it is in all its request-pull
>>> format glory:
>>>
>>> The following changes since commit 2422c8368337196594265d52cad7316c9404bfcf:
>>>   Stephen Rothwell (1):
>>>         Add linux-next specific files for 20120301
>>
>> OK, not commenting on anything else, but I cannot merge that into
>> linux-next because it is based on yesterday's linux-next release and
>> linux-next (effectively) rebases every day ...
>>
>> Does this work depend on anything in linux-next?  Or could it be just
>> based off Linus' tree.  If it depends on other tree(s) merged into
>> linux-next, then you should base your tree on those tree(s) as long as
>> they never get rebased ...
>
> Unfortunately, yes, it does -- there were both ptrace changes and prctl changes.
>
> And at least the ptrace changes are, IIRC, in -mm, which has no tree.
> :P Given that, what's the best thing for me to do for this to be easy
> for you to pull?
>

IIRC the prctl changes are in -linus.  I can rebase my part onto them.

--Andy
