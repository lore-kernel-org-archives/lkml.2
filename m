Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754159Ab2KMNUJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Nov 2012 08:20:09 -0500
Received: from mx1.unsolicited.net ([173.255.193.191]:40385 "EHLO
	mx1.unsolicited.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753054Ab2KMNUH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Nov 2012 08:20:07 -0500
Message-ID: <20121113132005.18175fvip3l0qjgl@vinovium.com>
Date: Tue, 13 Nov 2012 13:20:05 +0000
From: David R <david@unsolicited.net>
To: richard -rw- weinberger <richard.weinberger@gmail.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: Sched - trivial spelling patch
References: <20121113121329.94457adzis4fk5t5@vinovium.com>
 <CAFLxGvznPRr=7Q0ePyggOjWN2V0oZULty9eXb1S3+YCfF3Y8_Q@mail.gmail.com>
In-Reply-To: <CAFLxGvznPRr=7Q0ePyggOjWN2V0oZULty9eXb1S3+YCfF3Y8_Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8;
 DelSp="Yes";
 format="flowed"
Content-Disposition: inline
Content-Transfer-Encoding: 7bit
User-Agent: Internet Messaging Program (IMP) H3 (4.3.11)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting richard -rw- weinberger <richard.weinberger@gmail.com>:

> Your patch is missing a Signed-off-by tag.
> Please use checkpatch.pl to verify your patch.

I really didn't think it was significant enough to bother to be frank.

> On the other hand I'm not sure if this change is a good idea.
> sched_tunable_scaling_names is exposed to user space,
> changing a member may break existing applications.

I didn't notice that, it just irritates every time I look at  
/proc/sched_debug. If it has to be it has to be :-)

Cheers
David


