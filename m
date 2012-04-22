Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752073Ab2DVH00 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 03:26:26 -0400
Received: from mail-gy0-f174.google.com ([209.85.160.174]:64117 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751784Ab2DVH0Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 03:26:25 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
	<20120422040715.GA30689@elliptictech.com>
	<CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
Date: Sun, 22 Apr 2012 08:26:25 +0100
Message-ID: <CAPM=9tx9=mCEv-K8y95O-L6+8vWk4gt42ncFyNivV1S8T-9ykA@mail.gmail.com>
Subject: Re: Linux 3.4-rc4
From: Dave Airlie <airlied@gmail.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: David Airlie <airlied@linux.ie>, Ben Skeggs <bskeggs@redhat.com>,
        Martin Peres <martin.peres@labri.fr>, dri-devel@lists.freedesktop.org,
        Nick Bowler <nbowler@elliptictech.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Apr 22, 2012 at 5:51 AM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
> David & co, any ideas?

I've been asking Ben about this, I might have to use a bit more pressure,

It would be worth bisecting drivers/gpu/drm only, I doubt its going to
be outside that area.

Dave.
