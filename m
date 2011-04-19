Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144Ab1DSHfi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Apr 2011 03:35:38 -0400
Received: from mail-yi0-f46.google.com ([209.85.218.46]:49798 "EHLO
	mail-yi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752960Ab1DSHfe convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Apr 2011 03:35:34 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :cc:content-type:content-transfer-encoding;
        b=iexXL4EdKPyXij7wTXy1dE16SLvulHBVV1/BCiHe0nFndRyDz5w5YJ111V+GmqYBni
         PsuxIhSLbw+r4hg0btKPn7KnwuFSxuPjpuAWJkZxYc4fOUdyVJMvGBrMZaBsoaibNcEv
         inwIg7/sKZ4M5YkWzSx1TGI7EpP0Yb1ZplgcI=
MIME-Version: 1.0
In-Reply-To: <4DAD327B.4030904@suse.cz>
References: <BANLkTikYuYVvXiHvi_kr2H7n29k=veThtw@mail.gmail.com>
	<4DAD327B.4030904@suse.cz>
Date: Tue, 19 Apr 2011 15:35:33 +0800
Message-ID: <BANLkTikspr9jVNF-VZbnc_MxUYNWad7Kkg@mail.gmail.com>
Subject: Re: LOCALVERSION in setlocalversion
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Michal Marek <mmarek@suse.cz>
Cc: zippel@linux-m68k.org, linux-kbuild@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 19, 2011 at 2:58 PM, Michal Marek <mmarek@suse.cz> wrote:
> On 19.4.2011 08:42, Haojian Zhuang wrote:
>> In scripts/setlocalversion under linux kernel tree, the scripts seems
>> a little strange.
> [...]
>>         # append a plus sign if the repository is not in a clean
>>         # annotated or signed tagged state (as git describe only
>>         # looks at signed or annotated tags - git tag -a/-s) and
>>         # LOCALVERSION= is not specified
>>         if test "${LOCALVERSION+set}" != "set"; then
>>                 scm=$(scm_version --short)
>>                 res="$res${scm:++}"
>>         fi
>> fi
>>
>> LOCALVERSION isn't assigned in any place. Only CONFIG_LOCALVERSION
>> can be assigned in .config file.
>> Why do we need to check LOCALVERSION at here?
>
> It can be set on the commandline:
>
> make LOCALVERSION=something
>
> Michal
>

Thanks a lot. It works.

I still have a question. I can't find the semantic of
${LOCALVERSION+set} in some
shell tutorials. Could you help me to figure out a link of introducing this?

Best Regards
Haojian
