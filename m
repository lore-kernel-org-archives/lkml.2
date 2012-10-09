Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755646Ab2JIWV0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Oct 2012 18:21:26 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45283 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754217Ab2JIWVX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Oct 2012 18:21:23 -0400
Date: Tue, 9 Oct 2012 19:21:20 -0300
From: Mauro Carvalho Chehab <mchehab@redhat.com>
To: Ezequiel Garcia <elezegarcia@gmail.com>
Cc: Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [GIT PULL for 3.7-rc1] media updates - part 1
Message-ID: <20121009192120.3d071497@redhat.com>
In-Reply-To: <CALF0-+XQW1RrHQN4=5fzLLsdJESrLnhSwW3yD9rK+huP5dUOqQ@mail.gmail.com>
References: <20121005104259.03c94150@redhat.com>
	<CALF0-+XQW1RrHQN4=5fzLLsdJESrLnhSwW3yD9rK+huP5dUOqQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Tue, 9 Oct 2012 14:43:46 -0300
Ezequiel Garcia <elezegarcia@gmail.com> escreveu:

> On Fri, Oct 5, 2012 at 10:42 AM, Mauro Carvalho Chehab
...
> > Ezequiel García (13):
> >       [media] em28xx: Remove useless runtime->private_data usage
> >       [media] media: Add stk1160 new driver (easycap replacement)
> >       [media] staging: media: Remove easycap driver
> 
> Hi Mauro,
> 
> We've replaced easycap staging driver with stk1160.
> However, stk1160 still misses s-video input support, which I believe
> easycap had.
> 
> This feature was missing because I couldn't get s-video devices to test with,
> but now a couple users have provided the test and the patch is ready.
> It's a tiny patch routing saa7115 properly.

Ok. Let's add it them.

> I think we should include this feature in v3.7 to complete easycap ->
> stk1160 replacement.

Yes, that's make sense for me. As easycap is a new driver, there's no
regression on adding a patch like that, even after the merge window,
especially since input selection is typically a trivial change that
won't cause bad effects.

Please send the patch. I'll likely submit it upstream by next week,
after giving some time for people to test it via the media tree.

> Also, it seems to me there's no point in keeping the driver until v3.8,
> since there aren't much users out there testing it.
> 
> On the other side, I don't want to mess with the flow, so it's
> completely up to you.
> If you think it's okey, then I can send the patch tonight and
> hopefully you can pick
> it for your second pull request.
> 
> Please let me know.
> 
>     Ezequiel

Regards,
Mauro
