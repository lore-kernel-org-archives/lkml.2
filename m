Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1945967Ab2JSWwX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Oct 2012 18:52:23 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:57991 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1945931Ab2JSWwV convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Oct 2012 18:52:21 -0400
MIME-Version: 1.0
In-Reply-To: <5081D72C.2080309@labri.fr>
References: <1724445.dN2yMEzN6d@localhost> <CA+55aFy8Te9VFaZRZSDYMehbfg-qLDBYv6=EKncQ2=J2XaF+Vg@mail.gmail.com>
 <5081D72C.2080309@labri.fr>
From: Linus Torvalds <torvalds@linux-foundation.org>
Date: Fri, 19 Oct 2012 15:52:01 -0700
X-Google-Sender-Auth: enXMVpGxQxs5L6ZCa-M_8mPjVEo
Message-ID: <CA+55aFyDEsxEfEDt=qQqp5XjdYVJcQLJwzCf0g+gNAZ1NknSyQ@mail.gmail.com>
Subject: Re: Linux 3.7-rc1 (nouveau_bios_score oops).
To: Martin Peres <martin.peres@labri.fr>
Cc: =?ISO-8859-2?Q?Pawe=B3_Sikora?= <pawel.sikora@agmk.net>,
        David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        marcheu@chromium.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 19, 2012 at 3:41 PM, Martin Peres <martin.peres@labri.fr> wrote:
>
> You must have missed the oops that was attached to the mail:
> http://www.spinics.net/lists/kernel/msg1420355.html

I did indeed. So never mind about that dmesg request, Paweł ;-p

> Paweł, could you try the attached patch please ?

Thanks for being on it,

             Linus
