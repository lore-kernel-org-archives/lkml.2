Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756785Ab2JWHT1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Oct 2012 03:19:27 -0400
Received: from mail.parknet.co.jp ([210.171.160.6]:53765 "EHLO
	mail.parknet.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756770Ab2JWHTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Oct 2012 03:19:23 -0400
From: OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
To: Namjae Jeon <linkinjeon@gmail.com>
Cc: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        Ravishankar N <cyberax82@gmail.com>,
        Amit Sahrawat <amit.sahrawat83@gmail.com>,
        linux-fsdevel <linux-fsdevel@vger.kernel.org>
Subject: Re: [PATCH v2] fat: editions to support fat_fallocate()
References: <1350138661-2454-1-git-send-email-linkinjeon@gmail.com>
	<87lif958lb.fsf@devron.myhome.or.jp>
	<CAKYAXd9CQoYBHb0S4bpU0-6QMwMvfC7m=RhDCYPzKwXfvu7VKw@mail.gmail.com>
	<87txtu206u.fsf@devron.myhome.or.jp>
	<CAKYAXd_R=FRv8+0uATLSG+JLSm7Vkb4g+_qRkqpaDf8vM4Fpdg@mail.gmail.com>
	<878vazl6tw.fsf@devron.myhome.or.jp>
	<CAKYAXd_TaaL1-wh2UFDTRvqQ8QtWLbuiSPeXrzV_=amoT9YCyg@mail.gmail.com>
Date: Tue, 23 Oct 2012 16:19:14 +0900
In-Reply-To: <CAKYAXd_TaaL1-wh2UFDTRvqQ8QtWLbuiSPeXrzV_=amoT9YCyg@mail.gmail.com>
	(Namjae Jeon's message of "Tue, 23 Oct 2012 00:10:03 +0900")
Message-ID: <877gqhk64t.fsf@devron.myhome.or.jp>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.2.50 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Namjae Jeon <linkinjeon@gmail.com> writes:

>> Does this break the linux fat driver doesn't know about this
>> fallocate()?  If so, it sounds like to be easy to break existent
>> drivers.
> Yes, it will break linux drivers without fallocate support. When we
> try to write to fallocated file using old drivers, it will cause write
> error and make FS read-only.
> When fallocate was implemented in other filesystem, maybe,, was there
> similar issue and concern  ?

I guess it is not similar. Because other FS can change the spec (e.g. it
can be possible to use feature compat flag for it).
-- 
OGAWA Hirofumi <hirofumi@mail.parknet.co.jp>
