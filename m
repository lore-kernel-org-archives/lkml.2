Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932177Ab2JWHYQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:24:16 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:65519 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756678Ab2JWHYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:24:14 -0400
MIME-Version: 1.0
In-Reply-To: <877gqhk64t.fsf@devron.myhome.or.jp>
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<87lif958lb.fsf@devron.myhome.or.jp>
	<CAKYAXd9CQoYBHb0S4bpU0-6QMwMvfC7m=RhDCYPzKwXfvu7VKw@mail.gmail.com>
	<87txtu206u.fsf@devron.myhome.or.jp>
	<CAKYAXd_R=FRv8+0uATLSG+JLSm7Vkb4g+_qRkqpaDf8vM4Fpdg@mail.gmail.com>
	<878vazl6tw.fsf@devron.myhome.or.jp>
	<CAKYAXd_TaaL1-wh2UFDTRvqQ8QtWLbuiSPeXrzV_=amoT9YCyg@mail.gmail.com>
	<877gqhk64t.fsf@devron.myhome.or.jp>
Date: Tue, 23 Oct 2012 16:24:12 +0900
Message-ID: <CAKYAXd9CmZ+4j4eF0LmWLpE_ma_kKqEjEzAUOhpcCDY4UR_UBw@mail.gmail.com>
Subject: Re: [PATCH v2] fat: editions to support fat_fallocate()
From: Namjae Jeon <linkinjeon@gmail.com>
To: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2012/10/23, OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>:
> Namjae Jeon <linkinjeon@gmail.com> writes:
>
>>> Does this break the linux fat driver doesn't know about this
>>> fallocate()?  If so, it sounds like to be easy to break existent
>>> drivers.
>> Yes, it will break linux drivers without fallocate support. When we
>> try to write to fallocated file using old drivers, it will cause write
>> error and make FS read-only.
>> When fallocate was implemented in other filesystem, maybe,, was there
>> similar issue and concern  ?
>
> I guess it is not similar. Because other FS can change the spec (e.g. it
> can be possible to use feature compat flag for it).
Hi. OGAWA.
Okay, I agree.
Thanks for your interest.

> --
> OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
>
