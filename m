Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752517Ab1FNMi4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jun 2011 08:38:56 -0400
Received: from mail-ew0-f46.google.com ([209.85.215.46]:62317 "EHLO
	mail-ew0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751109Ab1FNMix (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jun 2011 08:38:53 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=message-id:date:from:user-agent:mime-version:to:cc:subject
         :references:in-reply-to:content-type:content-transfer-encoding;
        b=MdGqgWqpU/qNLxBiMwgHsRiPDIwwCVcySgqZzGVcG9moCeJ62YkSIM9EgsiZw3tilg
         e3LMBkr9Rl0GEta1sDZ0Pkl0uU2pK4fPe8hkw1RH73BA9ye32DzEW3kFcwhq/duM/n2S
         QtgGD42ridXZ4IwqXoupVewughmGjTzNaUoAA=
Message-ID: <4DF75659.5010000@gmail.com>
Date: Tue, 14 Jun 2011 14:38:49 +0200
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.2.15) Gecko/20110419 Thunderbird/3.1.9
MIME-Version: 1.0
To: Denys Vlasenko <vda.linux@googlemail.com>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.0-rc3
References: <BANLkTinCfV4owNBhJ+F-yfF3V+wg1o=PLA@mail.gmail.com> <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com>
In-Reply-To: <BANLkTim_bHKdZnykedzW4re6GMCg+1Ed2g@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Op 14-06-11 14:15, Denys Vlasenko schreef:
> On Tue, Jun 14, 2011 at 1:01 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
>> .. and this time even with a timely tar-ball, since I'm not traveling any more.
>>
>> What do we have in it? More than in -rc2. I'm clearly not the only one
>> who was in Japan for LinuxCon, or something else just made people wake
>> up.
> Linus, I know I run a risk of being not the first person to ask this,
> but anyway.
>
> I've got a patch for my project to fix parsing of kernel version which
> has only two numbers. Basically,
>
> - scanf(ver, "%u.%u.%u", &a, &b, &c)
> + sscanf(ver, "%u.%u", &a, &b)
>
> I can take it, but it made me thinking: how many other projects
> will be similarly affected? Must be hundreds, even thousands.
>
> I propose to still use three digits. I mean, if you want to use
> 3.0, 3.1, 3.2 numbering for your releases and leave third digit
> for stable series, just number them 3.0.0, 3.1.0, 3.2.0 instead.
>
> This way, many userspace projects will need less patching
> in order to work with 3.x. In many cases, they can
> avoid patching altogether.
>
~$ uname -r
3.0.0-rc3-patser+

~Maarten
