Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932406Ab2JKWpN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Oct 2012 18:45:13 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:39895 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932191Ab2JKWpI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Oct 2012 18:45:08 -0400
MIME-Version: 1.0
In-Reply-To: <20121011151925.5fcafe7c.akpm@linux-foundation.org>
References: <alpine.LRH.2.02.1210112153030.9640@tundra.namei.org>
	<20121011151925.5fcafe7c.akpm@linux-foundation.org>
Date: Fri, 12 Oct 2012 00:45:06 +0200
Message-ID: <CAFLxGvzgUQLNH5oXkB8r385=bT-qVAMn5354PSKhVkF4BojK3w@mail.gmail.com>
Subject: Re: [GIT] TPM bugfixes
From: richard -rw- weinberger <richard.weinberger@gmail.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: James Morris <jmorris@namei.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, linux-security-module@vger.kernel.org,
        Kent Yoder <key@linux.vnet.ibm.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 12, 2012 at 12:19 AM, Andrew Morton
<akpm@linux-foundation.org> wrote:
> On Thu, 11 Oct 2012 21:54:18 +1100 (EST)
> James Morris <jmorris@namei.org> wrote:
>
>> Please pull these fixes for the TPM code.
>>
>> The following changes since commit 12250d843e8489ee00b5b7726da855e51694e792:
>>
>>   Merge branch 'i2c-embedded/for-next' of git://git.pengutronix.de/git/wsa/linux (2012-10-11 10:27:51 +0900)
>>
>> are available in the git repository at:
>>
>>   git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git for-linus
>
> Gargh.  Is it possible to add a human-readable http URL to these things
> so that people can actually look at the patches without hoop-jumping?

rw@mantary:~> echo
"git://git.kernel.org/pub/scm/linux/kernel/git/jmorris/linux-security.git
for-linus" | sed -e
's/git\:\/\//http\:\/\//;s/\/pub\/scm\//\?p=/g;s/\.git
/\.git\;a=shortlog;h=refs\/heads\//g'

http://git.kernel.org?p=linux/kernel/git/jmorris/linux-security.git;a=shortlog;h=refs/heads/for-linus

-- 
Thanks,
//richard
