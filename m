Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab3AHUkv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jan 2013 15:40:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:55740 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3AHUkt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jan 2013 15:40:49 -0500
Message-ID: <50EC8447.1000301@canonical.com>
Date: Tue, 08 Jan 2013 12:40:39 -0800
From: John Johansen <john.johansen@canonical.com>
Organization: Canonical
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: James Morris <jmorris@namei.org>
CC: Casey Schaufler <casey@schaufler-ca.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        LSM <linux-security-module@vger.kernel.org>,
        LKLM <linux-kernel@vger.kernel.org>, SE Linux <selinux@tycho.nsa.gov>,
        Eric Paris <eparis@redhat.com>,
        Tetsuo Handa <penguin-kernel@i-love.sakura.ne.jp>,
        Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [PATCH v12 0/9] LSM: Multiple concurrent LSMs
References: <50EB7C50.3070605@schaufler-ca.com> <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au> <50EB9A5E.1080306@schaufler-ca.com> <alpine.LRH.2.02.1301081942030.24212@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1301081942030.24212@tundra.namei.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/08/2013 01:12 AM, James Morris wrote:
> On Mon, 7 Jan 2013, Casey Schaufler wrote:
> 
>> There has been an amazing amount of development in system security
>> over the past three years. Almost none of it has been in the kernel.
>> One important reason that it is not getting done in the kernel is
>> that the current single LSM restriction requires an all or nothing
>> approach to security. Either you address all your needs with a single
>> LSM or you have to go with a user space solution, in which case you
>> may as well do everything in user space.
> 
> This sounds like a very spurious argument.  If the development is better 
> done in userspace, then do it there.
> 
> There's no way to address all your security needs with an LSM in any case, 
> for any practical system.  LSM is an API for making security decisions 
> about kernel flow, usually as part of implementing access control 
> mechanisms.  It is not meant to provide any kind of total security 
> solution, and the argument that you can't do some security in userspace is 
> totally illogical.
> 
> Development should be done in userspace unless it must be done in the 
> kernel.
> 
>> Multiple concurrent LSMs allows a system to be developed incrementally
>> and to combine a variety of approaches that meet new and interesting
>> needs. It allows for systems that are based on an LSM that does not
>> meet all of the requirements but that can be supplemented by another
>> LSM that fills the gaps. It allows an LSM like Smack that implements
>> label based access controls to remain true to its purpose even in the
>> face of pressure to add controls based on other mechanisms.
>>
>> I have had requests for running Smack and AppArmor together Tetsuo has
>> long had need to put SELinux and TOMOYO on the same box. Yama was
>> recently special cased for stackability.
> 
> I'd say we need to see the actual use-case for Smack and Apparmor being 
> used together, along with at least one major distro committing to support 
> this.
> 
>
Ubuntu is very interested in stacking


