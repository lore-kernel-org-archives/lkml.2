Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757715Ab1KJPQA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Nov 2011 10:16:00 -0500
Received: from mail-yw0-f46.google.com ([209.85.213.46]:50486 "EHLO
	mail-yw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752492Ab1KJPP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Nov 2011 10:15:59 -0500
Date: Fri, 11 Nov 2011 00:15:48 +0900
From: =?utf-8?B?SsOpcsO0bWU=?= Pinot <ngc891@gmail.com>
To: Nick Bowler <nbowler@elliptictech.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: Evolution of kernel size
Message-ID: <20111110151548.GA8557@comet.deepsky.org>
References: <20111110143333.GA29457@comet.deepsky.org>
 <20111110145902.GA13619@elliptictech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20111110145902.GA13619@elliptictech.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/10/11 09:59, Nick Bowler wrote:
> On 2011-11-10 23:33 +0900, Jérôme Pinot wrote:
> > I took some time to make a graph of the evolution of the size of the
> > linux kernel tar.bz2 since version 1.0 till 3.1 (297 releases).
> > It doesn't count the stable branches (2.6.x.y).
> > 
> > Impressive, it's mostly exponential.
> > If dev keeps same pace, we should break the 100MB at
> > linux 3.19.
> > 
> > You can get the graph on my blog, I provide the data and the
> > gnuplot batch file for graphing/fitting:
> > http://ngc891.blogdns.net/?p=92 
> > 
> > It may interest some people :-)
> 
> What scale did you use for the horizontal axis?  I see numbers assigned
> to each version in your gnuplot file, but no indication of how you came
> up with them.

It's just the release count, one step for one release.

Some release are missing, mostly at the very beginning, I didn't find
tarball for them but it doesn't matter much for the shape of the curve.

-- 
Jérôme Pinot
http://ngc891.blogdns.net/
