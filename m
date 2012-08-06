Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756607Ab2HFPr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 11:47:57 -0400
Received: from mail-wi0-f172.google.com ([209.85.212.172]:42208 "EHLO
	mail-wi0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756409Ab2HFPr4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 11:47:56 -0400
MIME-Version: 1.0
In-Reply-To: <041cb4ce-48ae-4600-9f11-d722bc03b9cc@default>
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com>
	<b95aec06-5a10-4f83-bdfd-e7f6adabd9df@default>
	<20120727205932.GA12650@localhost.localdomain>
	<d4656ba5-d6d1-4c36-a6c8-f6ecd193b31d@default>
	<5016DE4E.5050300@linux.vnet.ibm.com>
	<f47a6d86-785f-498c-8ee5-0d2df1b2616c@default>
	<20120731155843.GP4789@phenom.dumpdata.com>
	<20120731161916.GA4941@kroah.com>
	<20120731175142.GE29533@phenom.dumpdata.com>
	<20120806003816.GA11375@bbox>
	<041cb4ce-48ae-4600-9f11-d722bc03b9cc@default>
Date: Mon, 6 Aug 2012 18:47:54 +0300
X-Google-Sender-Auth: L8MjSorVhpvgmXLJ5VKlVZMkPRo
Message-ID: <CAOJsxLHDcgxxu146QWXw0ZhMHMhFOquEFXhF55HK2mCjHzk7hw@mail.gmail.com>
Subject: Re: [PATCH 0/4] promote zcache from staging
From: Pekka Enberg <penberg@kernel.org>
To: Dan Magenheimer <dan.magenheimer@oracle.com>
Cc: Minchan Kim <minchan@kernel.org>, Konrad Wilk <konrad.wilk@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Seth Jennings <sjenning@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Robert Jennings <rcj@linux.vnet.ibm.com>,
        Nitin Gupta <ngupta@vflare.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 6, 2012 at 6:24 PM, Dan Magenheimer
<dan.magenheimer@oracle.com> wrote:
> IMHO, the fastest way to get the best zcache into the kernel and
> to distros and users is to throw away the "demo" version, move forward
> to a new solid well-designed zcache code base, and work together to
> build on it.  There's still a lot to do so I hope we can work together.

I'm not convinced it's the _fastest way_. You're effectively
invalidating all the work done under drivers/staging so you might end up
in review limbo with your shiny new code...

AFAICT, your best bet is to first clean up zcache under driver/staging
and get that promoted under mm/zcache.c. You can then move on to the
more controversial ramster and figure out where to put the clustering
code, etc.

                        Pekka
