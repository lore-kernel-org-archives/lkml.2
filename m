Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754120Ab1KYKeY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Nov 2011 05:34:24 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:58141 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752655Ab1KYKeX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Nov 2011 05:34:23 -0500
MIME-Version: 1.0
In-Reply-To: <20111125103011.18e167cd@lxorguk.ukuu.org.uk>
References: <20111116113007.5656a7b4823ba085a46c57ae@canb.auug.org.au>
	<20111125124913.405fc8360a185f3116adb5ec@canb.auug.org.au>
	<20111125103011.18e167cd@lxorguk.ukuu.org.uk>
Date: Fri, 25 Nov 2011 10:34:19 +0000
Message-ID: <CAPM=9twsvX=hFS9S01-ht8JHhAAy4uP8N5NxPUDY9UpbsvQWmw@mail.gmail.com>
Subject: Re: linux-next: build failure after merge of the drm tree
From: Dave Airlie <airlied@gmail.com>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, Dave Airlie <airlied@linux.ie>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jesse Barnes <jbarnes@virtuousgeek.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 25, 2011 at 10:30 AM, Alan Cox <alan@lxorguk.ukuu.org.uk> wrote:
>> Ping?
>
> As I said last time you asked this - the correct merge resolution is to
> pull the DRM updates and mark the staging GMA500 Kconfig "&& BROKEN". The
> staging driver is frozen while we merge outside of staging and will not
> be getting any attention at this point - changes there just mess up the
> move work which is far more important.
>
> Also nothing in staging should be allowed to hold up real work. The
> resolution for anything in staging blocking merges is to mark the staging
> parts && BROKEN IMHO
>

I just pushed jbarnes patch into my tree for now, at pushed out the
mainline gma500 code with it.

But if someone can send a patch to Greg to mark GMA500 broken in
staging that would be good.

Dave.
