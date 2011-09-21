Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752026Ab1IUFmF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 01:42:05 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60600 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751622Ab1IUFmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 01:42:02 -0400
MIME-Version: 1.0
In-Reply-To: <CAOJsxLHQdf-+HuwVsQtF26oY_oJf3BsVdDi3NyJDi7F0eD03Gw@mail.gmail.com>
References: <20110910064531.GA32536@moria>
	<CAOJsxLFPODubVEB3Tjg54C7jDKM8H-RCM_u5kvO1D0kKyjUYXQ@mail.gmail.com>
	<20110921025545.GB5521@moria>
	<CAOJsxLHQdf-+HuwVsQtF26oY_oJf3BsVdDi3NyJDi7F0eD03Gw@mail.gmail.com>
Date: Wed, 21 Sep 2011 08:42:01 +0300
X-Google-Sender-Auth: Vi14Bv9s2gt4LSn2NovESiuMgSs
Message-ID: <CAOJsxLGWoGqdv=tdBwWjM9-MD_Qm3ibMSGpp1j-tQLjMW-b-0A@mail.gmail.com>
Subject: Re: [GIT] Bcache version 12
From: Pekka Enberg <penberg@cs.helsinki.fi>
To: Kent Overstreet <kent.overstreet@gmail.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-fsdevel@vger.kernel.org, rdunlap@xenotime.net, axboe@kernel.dk,
        akpm@linux-foundation.org, neilb@suse.de
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 21, 2011 at 5:55 AM, Kent Overstreet
> <kent.overstreet@gmail.com> wrote:
>> Short version: bcache is for making IO faster.

On Wed, Sep 21, 2011 at 8:33 AM, Pekka Enberg <penberg@cs.helsinki.fi> wrote:
> That's helpful...

Your documentation isn't helpful either:

+Say you've got a big slow raid 6, and an X-25E or three. Wouldn't it be
+nice if you could use them as cache... Hence bcache.

So it's a cool hack but you fail to explain why someone wants to use
it. You also fail to explain why you decided to implement it the way
you did instead of making it more like fscache, for example.

Really, why do I need to go digging for this sort of information? It
feels almost as if you don't want people to review your code...

                        Pekka
