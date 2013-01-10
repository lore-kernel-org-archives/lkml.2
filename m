Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439Ab3AJK0J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jan 2013 05:26:09 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35843 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751521Ab3AJK0H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jan 2013 05:26:07 -0500
Message-ID: <50EE9733.2060409@canonical.com>
Date: Thu, 10 Jan 2013 02:25:55 -0800
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
References: <50EB7C50.3070605@schaufler-ca.com> <20130108140159.83c07fa6a680e355f024970f@canb.auug.org.au> <50EB9A5E.1080306@schaufler-ca.com> <alpine.LRH.2.02.1301081942030.24212@tundra.namei.org> <50EC8447.1000301@canonical.com> <alpine.LRH.2.02.1301100028160.5423@tundra.namei.org>
In-Reply-To: <alpine.LRH.2.02.1301100028160.5423@tundra.namei.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2013 05:28 AM, James Morris wrote:
> On Tue, 8 Jan 2013, John Johansen wrote:
> 
>>> I'd say we need to see the actual use-case for Smack and Apparmor being 
>>> used together, along with at least one major distro committing to support 
>>> this.
>>>
>>>
>> Ubuntu is very interested in stacking
> 
> Which modules?
> 
Well Yama which has now been special cased, and in the past there has been
discussion about other special case LSMs like case is proposing for module
loading. There has been interest around both selinux + apparmor and
smack + apparmor. I am not sure of all of the use cases that have lead to
such question but some of them have been around containers, with say
selinux on the host and apparmor in the container, or visa versa.


