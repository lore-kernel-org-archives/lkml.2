Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754798Ab2G3TTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Jul 2012 15:19:54 -0400
Received: from e5.ny.us.ibm.com ([32.97.182.145]:53160 "EHLO e5.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754269Ab2G3TTx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Jul 2012 15:19:53 -0400
Message-ID: <5016DE4E.5050300@linux.vnet.ibm.com>
Date: Mon, 30 Jul 2012 14:19:42 -0500
From: Seth Jennings <sjenning@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:14.0) Gecko/20120714 Thunderbird/14.0
MIME-Version: 1.0
To: Dan Magenheimer <dan.magenheimer@oracle.com>
CC: Konrad Rzeszutek Wilk <konrad@darnok.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Nitin Gupta <ngupta@vflare.org>, Minchan Kim <minchan@kernel.org>,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Robert Jennings <rcj@linux.vnet.ibm.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 0/4] promote zcache from staging
References: <1343413117-1989-1-git-send-email-sjenning@linux.vnet.ibm.com> <b95aec06-5a10-4f83-bdfd-e7f6adabd9df@default> <20120727205932.GA12650@localhost.localdomain> <d4656ba5-d6d1-4c36-a6c8-f6ecd193b31d@default>
In-Reply-To: <d4656ba5-d6d1-4c36-a6c8-f6ecd193b31d@default>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 12073019-5930-0000-0000-00000A5D4F06
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dan,

I started writing inline responses to each concern but that
was adding more confusion than clarity.  I would like to
focus the discussion.

The purpose of this patchset is to discuss the inclusion of
zcache into mainline during the 3.7 merge window.  zcache
has been a staging since v2.6.39 and has been maturing with
contributions from 15 developers (5 with multiple commits)
working on improvements and bug fixes.

I want good code in the kernel, so if there are particular
areas that need attention before it's of acceptable quality
for mainline we need that discussion.  I am eager to have
customers using memory compression with zcache but before
that I want to see zcache in mainline.

We agree with Konrad that zcache should be promoted before
additional features are included.  Greg has also expressed
that he would like promotion before attempting to add
additional features [1].  Including new features now, while
in the staging tree, adds to the complexity and difficultly
of reverifying zcache and getting it accepted into mainline.

[1] https://lkml.org/lkml/2012/3/16/472

Let's have this discussion.  If there are specific issues
that need to be addressed to get this ready for mainline
let's take them one-by-one and line-by-line with patches.

Seth

