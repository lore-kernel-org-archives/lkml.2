Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759456Ab2JLAKq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 20:10:46 -0400
Received: from oproxy11-pub.bluehost.com ([173.254.64.10]:59380 "HELO
	oproxy11-pub.bluehost.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1757163Ab2JLAKo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 20:10:44 -0400
Message-ID: <50775FFA.9040000@xenotime.net>
Date: Thu, 11 Oct 2012 17:10:34 -0700
From: Randy Dunlap <rdunlap@xenotime.net>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110323 Thunderbird/3.1.9
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: richard -rw- weinberger <richard.weinberger@gmail.com>,
        James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kent Yoder <key@linux.vnet.ibm.com>
Subject: Re: [GIT] TPM bugfixes
References: <alpine.LRH.2.02.1210112153030.9640@tundra.namei.org>	<20121011151925.5fcafe7c.akpm@linux-foundation.org>	<CAFLxGvzgUQLNH5oXkB8r385=bT-qVAMn5354PSKhVkF4BojK3w@mail.gmail.com>	<20121011154936.70a8b910.akpm@linux-foundation.org> <20121011160000.4e58c3de.akpm@linux-foundation.org>
In-Reply-To: <20121011160000.4e58c3de.akpm@linux-foundation.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Identified-User: {1807:box742.bluehost.com:xenotime:xenotime.net} {sentby:smtp auth 50.53.38.135 authed with rdunlap@xenotime.net}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/11/2012 04:00 PM, Andrew Morton wrote:

> On Thu, 11 Oct 2012 15:49:36 -0700
> Andrew Morton <akpm@linux-foundation.org> wrote:
> 
>> On Fri, 12 Oct 2012 00:45:06 +0200
>> richard -rw- weinberger <richard.weinberger@gmail.com> wrote:
>>
>>> On Fri, Oct 12, 2012 at 12:19 AM, Andrew Morton
>>> <akpm@linux-foundation.org> wrote:
>>>> On Thu, 11 Oct 2012 21:54:18 +1100 (EST)
>>>> James Morris <jmorris@namei.org> wrote:
>>>>
>>>>> Please pull these fixes for the TPM code.
>>>>>
>>>>> The following changes since commit 12250d843e8489ee00b5b7726da855e51694e792:
>>>>>
>>>>>   Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux (2012-10-11 10:27:51 +0900)
>>>>>
>>>>> are available in the git repository at:
>>>>>
>>>>>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus
>>>>
>>>> Gargh.  Is it possible to add a human-readable http URL to these things
>>>> so that people can actually look at the patches without hoop-jumping?
>>>
>>> rw@mantary:~> echo
>>> "git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
>>> for-linus" | sed -e
>>> 's/git\:\/\//http\:\/\//;s/\/pub\/scm\//\?p=/g;s/\.git
>>> /\.git\;a=shortlog;h=refs\/heads\//g'
>>>
>>> http://git.kernel.org?p=linux/kernel/git/jmorris/linux-security.git;a=shortlog;h=refs/heads/for-linus
>>>
>>
>> Geeze.
>>
>> Thanks.  Followed by ^F, copy-n-paste, then hope it's on the first page?
> 
> http://git.kernel.org/?p=linux/kernel/git/jmorris/linux-security.git;a=commit;h=abce9ac292e13da367bbd22c1f7669f988d931ac
> 
> Which can be shortened to something like
> 
> http://git.kernel.org/?p=linux/kernel/git/jmorris/linux-security.git;h=abce9ac2
> 
> Simply including the commit IDs would help a lot.  Including the full
> URL to each commit would be nicer.

absolutely (for full URL).

> I assume Junio owns that script?
> --


-- 
~Randy
