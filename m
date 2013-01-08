Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211Ab3AHUTg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:19:36 -0500
Received: from mail-ob0-f173.google.com ([209.85.214.173]:44890 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751210Ab3AHUTe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:19:34 -0500
MIME-Version: 1.0
In-Reply-To: <50EC53E3.6070606@schaufler-ca.com>
References: <50EB7C50.3070605@schaufler-ca.com>
	<20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au>
	<50EB9A5E.1080306@schaufler-ca.com>
	<alpine.LRH.2.02.1301081942030.24212@tundra.namei.org>
	<50EC53E3.6070606@schaufler-ca.com>
Date: Tue, 8 Jan 2013 12:19:34 -0800
X-Google-Sender-Auth: 8wMCacyaCqTu9gV90S6TbVyrNQs
Message-ID: <CAGXu5jLBVj=r0pXBiNxSsbOWEUw8NastXK1ucFL2n1tyVKr47g@mail.gmail.com>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
From: Kees Cook <keescook@chromium.org>
To: Casey Schaufler <casey@schaufler-ca.com>
Cc: James Morris <jmorris@namei.org>, Stephen Rothwell <sfr@canb.auug.org.au>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        John Johansen <john.johansen@canonical.com>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 9:14 AM, Casey Schaufler <casey@schaufler-ca.com> wrote:
> On 1/8/2013 1:12 AM, James Morris wrote:
>> Yama is special-cased and can stay that way.
>
> Yama is *not* a special case, it is an example. It is the kind
> of new thing that provides security that is not access control.
> It was special cased at the request of distros because there was
> no general mechanism for including it along with the primary
> LSM.

I think he meant "there is a CONFIG to special-case Yama", but yes,
Yama is a good example. Now that finit_module has landed, I intend to
send another micro-LSM to provide logic for blocking modules when the
root devices is read-only.

It would be another example of an LSM that needs to be stacked with others.

-Kees

--
Kees Cook
Chrome OS Security
