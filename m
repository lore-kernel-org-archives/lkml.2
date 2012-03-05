Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757013Ab2CEWve (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Mar 2012 17:51:34 -0500
Received: from mail-ww0-f44.google.com ([74.125.82.44]:53707 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751806Ab2CEWvd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Mar 2012 17:51:33 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of linus971@gmail.com designates 10.216.132.222 as permitted sender) smtp.mail=linus971@gmail.com; dkim=pass header.i=linus971@gmail.com
MIME-Version: 1.0
In-Reply-To: <86ipiiisju.fsf@sumi.keithp.com>
References: <alpine.DEB.2.00.1203051856130.31585@skynet.skynet.ie>
 <CA+55aFw6w85_6wCTcB_AvXnRgFYhkB8rxpe9FOei3j0ZpGf0FQ@mail.gmail.com> <86ipiiisju.fsf@sumi.keithp.com>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Mon, 5 Mar 2012 14:51:12 -0800
X-Google-Sender-Auth: jhneLYOeuBuChQNxLfi9pysLE3I
Message-ID: <CA+55aFyuieJ-Ac2Y2C=KXBWkgheD6rEic4YqObx5jvM1Cg=GQQ@mail.gmail.com>
Subject: Re: [git pull] drm gma500 fix
To: Keith Packard <keithp@keithp.com>
Cc: Dave Airlie <airlied@linux.ie>, linux-kernel@vger.kernel.org,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 5, 2012 at 2:36 PM, Keith Packard <keithp@keithp.com> wrote:
> <#part sign=pgpmime>
> On Mon, 5 Mar 2012 14:09:13 -0800, Linus Torvalds <torvalds@linux-foundation.org> wrote:
>> Hmm. Is freedesktop.org having trouble?
>
> ECC memory errors -- we're moving this stuff to a new machine as quickly
> as rsync can run...

Ok. I'll just take Alan's patch directly as a patch.

No worries.

                    Linus
