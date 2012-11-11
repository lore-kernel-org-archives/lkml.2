Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752790Ab2KKMXf (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Nov 2012 07:23:35 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:49602 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752730Ab2KKMXe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Nov 2012 07:23:34 -0500
MIME-Version: 1.0
In-Reply-To: <3855.124.205.227.162.1352635619.squirrel@mprc.pku.edu.cn>
References: <20121109093508.BD26A1460351@linuxdev-32> <CA+55aFzjQATP7WCeK6hHbjEG5yLksB50GcpB7NAJGg=bWRPBQg@mail.gmail.com>
 <3855.124.205.227.162.1352635619.squirrel@mprc.pku.edu.cn>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Sun, 11 Nov 2012 13:23:12 +0100
X-Google-Sender-Auth: QOhpqmJ5ktjQ_4Nw7HukbTIPfRg
Message-ID: <CA+55aFxTipd+cRU0DY_PPWHvSvOH+BL7C1b2t6sV8FfyySTchw@mail.gmail.com>
Subject: Re: [GIT PULL REQUEST] UniCore32 update for v3.7-rc4
To: Guan <guanxuetao@mprc.pku.edu.cn>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Did you do the "request-pull" *after* you had done all the above?

The ..BRANCH.NOT.VERIFIED.. implies that the request-pull couldn't
find the particular tag.

Also, if you have an older version of git, you need to tell
request-pull explicitly that it is a tag, by saying "tags/for-linus"
rather than just "for-linus". Newer versions of git don't need that.

              Linus

On Sun, Nov 11, 2012 at 1:06 PM,  <guanxuetao@mprc.pku.edu.cn> wrote:
>> On Fri, Nov 9, 2012 at 10:35 AM, guanxuetao <guanxuetao@mprc.pku.edu.cn>
>> wrote:
>>>
>>>   git://github.com/gxt/linux.git ..BRANCH.NOT.VERIFIED..
>>
>> Let's try that again. With you checking what you send me. I hope
>> there's a signed tag somewhere, but the above certainly isn't that..
>>
>>              Linus
>>
>
> I used following command to generate a signed tag.
>   'git tag for-linus -s -u gxt@mprc.pku.edu.cn'
> Then, I pushed this tag into github.com by:
>   'git push github -f --tags'
> Finally, I checked github repo, and tag 'for-linus' can be found.
>
> Could you tell me what's wrong with my operation?
>
> Thanks & Regards,
> Guan Xuetao
