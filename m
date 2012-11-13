Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752721Ab2KMGt7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 01:49:59 -0500
Received: from mprc.pku.edu.cn ([162.105.203.9]:43292 "EHLO mprc.pku.edu.cn"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751067Ab2KMGt6 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 01:49:58 -0500
From: "Guan Xuetao" <gxt@mprc.pku.edu.cn>
To: "'Linus Torvalds'" <torvalds@linux-foundation.org>,
        "'Guan'" <guanxuetao@mprc.pku.edu.cn>
Cc: "'Linux Kernel Mailing List'" <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL REQUEST] UniCore32 update for v3.7-rc4
Date: Tue, 13 Nov 2012 14:49:45 +0800
Message-ID: <036301cdc16b$11eb09d0$35c11d70$@mprc.pku.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain;
	charset="gb2312"
Content-Transfer-Encoding: 8BIT
X-Mailer: Microsoft Outlook 14.0
thread-index: Ac3BasKTKaWtTTwmQz6i02iPkVgTRA==
Content-Language: zh-cn
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



> -----邮件原件-----
> 发件人: linus971@gmail.com [mailto:linus971@gmail.com] 代表 Linus Torvalds
> 发送时间: 2012年11月11日 20:23
> 收件人: Guan
> 抄送: Linux Kernel Mailing List
> 主题: Re: [GIT PULL REQUEST] UniCore32 update for v3.7-rc4
> 
> Did you do the "request-pull" *after* you had done all the above?
> 
> The ..BRANCH.NOT.VERIFIED.. implies that the request-pull couldn't
> find the particular tag.

I see. I've forgotten to push the new branch into the github.

Thanks & Regards,
Guan Xuetao

> 
> Also, if you have an older version of git, you need to tell
> request-pull explicitly that it is a tag, by saying "tags/for-linus"
> rather than just "for-linus". Newer versions of git don't need that.
> 
>               Linus
> 
> On Sun, Nov 11, 2012 at 1:06 PM,  <guanxuetao@mprc.pku.edu.cn> wrote:
> >> On Fri, Nov 9, 2012 at 10:35 AM, guanxuetao <guanxuetao@mprc.pku.edu.cn>
> >> wrote:
> >>>
> >>>   git://github.com/gxt/linux.git ..BRANCH.NOT.VERIFIED..
> >>
> >> Let's try that again. With you checking what you send me. I hope
> >> there's a signed tag somewhere, but the above certainly isn't that..
> >>
> >>              Linus
> >>
> >
> > I used following command to generate a signed tag.
> >   'git tag for-linus -s -u gxt@mprc.pku.edu.cn'
> > Then, I pushed this tag into github.com by:
> >   'git push github -f --tags'
> > Finally, I checked github repo, and tag 'for-linus' can be found.
> >
> > Could you tell me what's wrong with my operation?
> >
> > Thanks & Regards,
> > Guan Xuetao

