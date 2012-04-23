Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753565Ab2DWDLL (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Apr 2012 23:11:11 -0400
Received: from mx1.redhat.com ([209.132.183.28]:4085 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753298Ab2DWDLK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Apr 2012 23:11:10 -0400
Message-ID: <1335150978.6913.3.camel@nisroch>
Subject: Re: Linux 3.4-rc4
From: Ben Skeggs <bskeggs@redhat.com>
Reply-To: bskeggs@redhat.com
To: Dave Airlie <airlied@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Nick Bowler <nbowler@elliptictech.com>,
        Martin Peres <martin.peres@labri.fr>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        dri-devel@lists.freedesktop.org
Date: Mon, 23 Apr 2012 13:16:18 +1000
In-Reply-To: <CAPM=9tx9=mCEv-K8y95O-L6+8vWk4gt42ncFyNivV1S8T-9ykA@mail.gmail.com>
References: <CA+55aFzQD4UyPVDQesrWq7JkM=BoQevdJpQt1YyaG10MtfM-Pw@mail.gmail.com>
	 <20120422040715.GA30689@elliptictech.com>
	 <CA+55aFwGrb_sOjHFWe6tYwf8mmNsFbqKAhz=bq2ofiU+F+wVvA@mail.gmail.com>
	 <CAPM=9tx9=mCEv-K8y95O-L6+8vWk4gt42ncFyNivV1S8T-9ykA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2012-04-22 at 08:26 +0100, Dave Airlie wrote:
> On Sun, Apr 22, 2012 at 5:51 AM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> > David & co, any ideas?
> 
> I've been asking Ben about this, I might have to use a bit more pressure,
I unfortunately haven't yet had any ideas which could be useful aside
from continuing to try and narrow down the change that caused the issue.

I've been using the VGA output on a lot of different boards (including
of the same generation as the one in the original bug report) with the
latest code without an issue..

Ben.

> 
> It would be worth bisecting drivers/gpu/drm only, I doubt its going to
> be outside that area.
> 
> Dave.
> _______________________________________________
> dri-devel mailing list
> dri-devel@lists.freedesktop.org
> http://lists.freedesktop.org/mailman/listinfo/dri-devel


