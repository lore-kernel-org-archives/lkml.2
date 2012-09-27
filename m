Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2I0BkY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Sep 2012 21:40:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:57283 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753382Ab2I0BkW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Sep 2012 21:40:22 -0400
Date: Wed, 26 Sep 2012 18:47:43 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Minchan Kim <minchan@kernel.org>
Cc: Pekka Enberg <penberg@kernel.org>, Jens Axboe <axboe@kernel.dk>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Nitin Gupta <ngupta@vflare.org>,
        Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Seth Jennings <sjenning@linux.vnet.ibm.com>,
        Dan Magenheimer <dan.magenheimer@oracle.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] zsmalloc: promote to lib/
Message-Id: <20120926184743.3dca1289.akpm@linux-foundation.org>
In-Reply-To: <20120927013912.GB10229@bbox>
References: <1348649419-16494-1-git-send-email-minchan@kernel.org>
	<1348649419-16494-2-git-send-email-minchan@kernel.org>
	<CAOJsxLGjp5PAgPe3KSvMfqJEyVC4YHeP+FW3AmnCorpHqnfang@mail.gmail.com>
	<20120927013912.GB10229@bbox>
X-Mailer: Sylpheed 2.7.1 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 27 Sep 2012 10:39:12 +0900 Minchan Kim <minchan@kernel.org> wrote:

> So I and Nitin tried to ask the opinion to akpm several times
> (at least 5 and even I sent such patch a few month ago) but didn't get
> any reply from him so I guess he doesn't have any concern about that
> any more.

I just haven't yet set aside a sufficiently large lump of time to work
out what's going on here, sorry.  Will try to get onto it next week. 
