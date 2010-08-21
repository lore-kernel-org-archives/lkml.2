Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752181Ab0HUT0o (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Aug 2010 15:26:44 -0400
Received: from mail-qw0-f46.google.com ([209.85.216.46]:46884 "EHLO
	mail-qw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752055Ab0HUT0m convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Aug 2010 15:26:42 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=mime-version:in-reply-to:references:date:message-id:subject:from:to
         :content-type:content-transfer-encoding;
        b=EGokEB+1wKApvpWTZ1d+ipSKl5DGcbDeJgCgws2g8sBvzod4pBQwTL8wPdNZnkoYlc
         HaDZf8vOmOaR/lv3rAZA7WCb3C3FiFlrz6z6bdTiWDCX47vhy2wTz+ok0o+p5jCwJ4MB
         GkKdXupH0tHSkqLjRZEYOQVlU1Y90w5FuZppU=
MIME-Version: 1.0
In-Reply-To: <AANLkTin22E7zF0aomc+t23X7bETzNv-WgLivV_j98+dq@mail.gmail.com>
References: <AANLkTi=9y=_NnC349523E_qgJ2nSk1++3Z_Phx+GMJW4@mail.gmail.com>
	<20100822042525.7168ac37.lisa@ltmnet.com>
	<AANLkTin22E7zF0aomc+t23X7bETzNv-WgLivV_j98+dq@mail.gmail.com>
Date: Sat, 21 Aug 2010 15:26:41 -0400
Message-ID: <AANLkTin7GPuDhjOxXwJ4-m3k95XbxsLMkNbRQUWR5goH@mail.gmail.com>
Subject: How the heck do I get started?
From: Someone Something <fordhaivat@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I have joined the kernel newbies mailing list, and I am reading
through the website.
A long term (3 month) goal for me would be to fix up the 0.01 kernel
so it compiles and boots.

If you look at the code in head.s and boot.s, they are written in
different styles, comments are different (| instead of # or ; ), do
have to get rid of them to make it compile correctly?

On Sat, Aug 21, 2010 at 2:25 PM, Lisa Milne <lisa@ltmnet.com> wrote:
> On Sat, 21 Aug 2010 13:56:19 -0400
> Someone Something <fordhaivat@gmail.com> wrote:
>
>> Hello everyone,
>>
>> I am a pretty so so C programmer (I've written small networked stuff,
>> a simple game engine, GUI tools etc.), I just do programming as a
>> hobby and I'm a middle school student. I am interested in low level
>> programming and I dabble in assembly, so, I downloaded the latest
>> kernel source and the sheer size of it just blows my mind. How should
>> I get started hacking on it? Writing modules, or just browsing through
>> the code and trying to understand it? Any books you guys recommend?
>> I'm pretty sure that you're sick and tired of these newb questions,
>> so, I actually did some research, and I do have a few concrete
>> questions.
>> 1) Does the linux kernel use pages AND segments? Or just one of them?
>> If its pages, how does it deal with the wasted memory at the end of
>> each page? Very small pages?
>> 2) I looked at the 0.01 kernel and it has this weird mix of nasm and
>> gas syntax for its assembly. Why's that?
>> 3) Is there some kind of tracker for the kernel where it lists bugs
>> and stuff?
>> 4) If I do have a patch I'd like to submit, how would I do this?
>>
>>
>> Thanks a lot,
>> Dhaivat
>> --
>> To unsubscribe from this list: send the line "unsubscribe
>> linux-kernel" in the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>
> Hi Dhaivat,
>
> I'd recommend you join the kernel newbies mailing list, and look around
> their website, it's the best place for getting started with kernel
> development.
>
> http://kernelnewbies.org/MailingList
>
> --
> Lisa Milne <lisa@ltmnet.com>
>
