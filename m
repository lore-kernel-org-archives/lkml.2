Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752322Ab1J0Mvz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Oct 2011 08:51:55 -0400
Received: from cantor2.suse.de ([195.135.220.15]:53324 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751827Ab1J0Mvy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Oct 2011 08:51:54 -0400
Message-ID: <4EA953E8.4020004@suse.cz>
Date: Thu, 27 Oct 2011 14:51:52 +0200
From: Michal Marek <mmarek@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:6.0.2) Gecko/20110907 Thunderbird/6.0.2
MIME-Version: 1.0
To: Ingo Molnar <mingo@elte.hu>
Cc: Pekka Enberg <penberg@kernel.org>, Sasha Levin <levinsasha928@gmail.com>,
        linux-kernel@vger.kernel.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] config: Add 'make kvmconfig'
References: <1319717234-20918-1-git-send-email-levinsasha928@gmail.com> <CAOJsxLH-O8+Fx=VLsoXhVLNtXWD_1eVrUMOgbk2DODbrwPAzhQ@mail.gmail.com> <20111027123713.GB22032@elte.hu>
In-Reply-To: <20111027123713.GB22032@elte.hu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27.10.2011 14:37, Ingo Molnar wrote:
> 
> * Pekka Enberg <penberg@kernel.org> wrote:
> 
>> On Thu, Oct 27, 2011 at 3:07 PM, Sasha Levin <levinsasha928@gmail.com> wrote:
>>> This patch adds 'make kvmconfig' which allows to add KVM guest support
>>> to a config file.
>>>
>>> This allows for easier testing of configurations under virtualized
>>> environments.
>>>
>>> Cc: Ingo Molnar <mingo@elte.hu>
>>> Cc: Linus Torvalds <torvalds@linux-foundation.org>
>>> Cc: Michal Marek <mmarek@suse.cz>
>>> Cc: Pekka Enberg <penberg@cs.helsinki.fi>
>>> Cc: linux-kbuild@vger.kernel.org
>>> Cc: linux-kernel@vger.kernel.org
>>> Suggested-by: Ingo Molnar <mingo@elte.hu>
>>> Signed-off-by: Sasha Levin <levinsasha928@gmail.com>
>>
>> Acked-by: Pekka Enberg <penberg@kernel.org>
>>
>> Btw, Michal, if people are OK with the patch I'd really love to 
>> take this patch in my kvmtool git tree to have it contained in a 
>> single pull request.
> 
> I like the feature - i hope it's expressed in the right Kbuild-ish 
> fashion.
> 
> Acked-by: Ingo Molnar <mingo@elte.hu>

I hope we won't now also be getting make nfsconfig, make paeconfig and
whatnot :). Also, the lists of select statements might need updates from
time to time, if new dependencies appear.

Michal
