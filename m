Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753780Ab0HBPPR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Aug 2010 11:15:17 -0400
Received: from cpoproxy3-pub.bluehost.com ([67.222.54.6]:49253 "HELO
	cpoproxy3-pub.bluehost.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753097Ab0HBPPP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Aug 2010 11:15:15 -0400
DomainKey-Signature: a=rsa-sha1; q=dns; c=nofws; s=default; d=virtuousgeek.org;
	h=Received:Date:From:To:Cc:Subject:Message-ID:In-Reply-To:References:X-Mailer:Mime-Version:Content-Type:Content-Transfer-Encoding:X-Identified-User;
	b=lSNLKQAfrjQySqrMUdRDzsiBYhVRiVW1sKXO9v2IjO5etdD4sGpL6yOvhImDEixxbFU6aNCjCGnBn6YA2H4ijaAblrpIPyZr5UGmmvddSdzCxbL466FvurmxEjSC2i4W;
Date: Mon, 2 Aug 2010 08:15:07 -0700
From: Jesse Barnes <jbarnes@virtuousgeek.org>
To: Dave Airlie <airlied@redhat.com>
Cc: Nicolas Kaiser <nikai@nikai.net>, linux-kernel@vger.kernel.org,
        dri-devel@lists.freedesktop.org
Subject: Re: [PATCH] drm: fixed brace, spacing and whitespace coding style
 issues
Message-ID: <20100802081507.5fa6f52d@virtuousgeek.org>
In-Reply-To: <1280708213.2393.2.camel@clockmaker-el6>
References: <20100714161131.296330a5@absol.kitzblitz>
	<1280708213.2393.2.camel@clockmaker-el6>
X-Mailer: Claws Mail 3.7.6 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Identified-User: {10642:box514.bluehost.com:virtuous:virtuousgeek.org} {sentby:smtp auth 75.110.194.140 authed with jbarnes@virtuousgeek.org}
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 02 Aug 2010 10:16:53 +1000
Dave Airlie <airlied@redhat.com> wrote:

> On Wed, 2010-07-14 at 16:11 +0200, Nicolas Kaiser wrote:
> > Fixed brace, spacing and whitespace coding style issues.
> 
> Failed to apply to drm-core-next, might always be a pain to get
> something like this to apply though, whitespace isn't top of my
> priorities most days.

I think you should just reject it, unless it comes as part of a series
with actual work in it.  At least that's been my policy lately...

-- 
Jesse Barnes, Intel Open Source Technology Center
