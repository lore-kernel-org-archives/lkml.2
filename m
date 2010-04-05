Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755434Ab0DEQUq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Apr 2010 12:20:46 -0400
Received: from 0122700014.0.fullrate.dk ([95.166.99.235]:48790 "EHLO kernel.dk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755173Ab0DEQUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Apr 2010 12:20:42 -0400
Date: Mon, 5 Apr 2010 18:20:40 +0200
From: Jens Axboe <jens.axboe@oracle.com>
To: Manuel Benitez <rickyb@google.com>
Cc: Vivek Goyal <vgoyal@redhat.com>, Corrado Zoccolo <czoccolo@gmail.com>,
       Jeff Moyer <jmoyer@redhat.com>,
       Gui Jianfeng <guijianfeng@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Expose the statistics in blkio.time and blkio.sectors
	for   the root cgroup
Message-ID: <20100405162040.GH23510@kernel.dk>
References: <1269473756-30327-1-git-send-email-rickyb@google.com> <20100325005228.GA13225@redhat.com> <v2g23904f641004050720pc0d7aa04n294381af44047dd3@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <v2g23904f641004050720pc0d7aa04n294381af44047dd3@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 05 2010, Manuel Benitez wrote:
> Jens,
> 
> Please let me know if this patch is/isn't acceptable. Not having the
> statistics exposed at the root is a little bit problematic for our
> user-level control programs.

It's fine with me, I'll queue it up.

-- 
Jens Axboe

