Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754028Ab1ASSHj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jan 2011 13:07:39 -0500
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.125]:45913 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753231Ab1ASSHi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jan 2011 13:07:38 -0500
X-Authority-Analysis: v=1.1 cv=3uSaImBeuprzHBlOOPjkqgu+7PcxSRW0m2Aphm9Zmck= c=1 sm=0 a=kj9zAlcOel0A:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=jbLP0KXJcOz0BbRaUrEA:9 a=TjtZIcRDpScOVP2it_G184gpHXwA:4 a=CjuIK1q_8ugA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Date: Wed, 19 Jan 2011 13:07:35 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: nobody <darwinskernel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 2.6.38-rc1
Message-ID: <20110119180735.GA9752@home.goodmis.org>
References: <AANLkTimajU0x1v6y3rH2+jr-bZ=tNLs1S_agXdGGAa3S@mail.gmail.com>
 <AANLkTimp0UcWi68N5Jv_hUww9PhGVgCzY0qYLETc8Dj_@mail.gmail.com>
 <1161CC5A-C8CA-477E-B2CE-7870F8E634EE@gmail.com>
 <AANLkTin+Div6HoAJdFOfqRFSMyxqx7ft7mcteXomaV_Y@mail.gmail.com>
 <20110119051049.GA2536@WALL-E>
 <AANLkTikdCek7DGN885Cjuo1nkswe_Y8KG6Knn8XknzsF@mail.gmail.com>
 <AANLkTikV6=FCQ+-Z=fAi8SH90M-izCUEBisinqGwo=DU@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTikV6=FCQ+-Z=fAi8SH90M-izCUEBisinqGwo=DU@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 18, 2011 at 09:56:38PM -0800, Linus Torvalds wrote:
> 
> Btw, what may confuse you a bit is that the on-disk representation of
> the newly received pack ends up being about 69MB, ie the 21MiB of
> network traffic almost tripled in size as a result of that "resolving
> deltas" thing. That's because git pack-files are designed to always be
> stand-alone, so on disk, the pack-file will always contain the base
> objects needed to expand all the deltas.

When I first started using git (2006?) I was recommended to use "-k"
when doing a fetch or pull. I don't even remember why it was
recommended. I still do it, but is it necessary?

All the help says is:

       -k, --keep
                  Keep downloaded pack.

-- Steve

