Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760260Ab2CNWsO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Mar 2012 18:48:14 -0400
Received: from mail-bk0-f46.google.com ([209.85.214.46]:54162 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757242Ab2CNWsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Mar 2012 18:48:05 -0400
Date: Thu, 15 Mar 2012 02:48:00 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Matt Helsley <matthltc@us.ibm.com>
Cc: Oleg Nesterov <oleg@redhat.com>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>,
        Pavel Emelyanov <xemul@parallels.com>,
        Kees Cook <keescook@chromium.org>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [RFC] c/r: prctl: Add ability to set new mm_struct::exe_file v3
Message-ID: <20120314224800.GE2778@moon>
References: <20120310074854.GA3065@moon>
 <20120313024511.GF19584@count0.beaverton.ibm.com>
 <20120313062625.GA1912@moon>
 <20120313071812.GA6969@moon>
 <20120313154337.GA25711@redhat.com>
 <20120313160044.GF1912@moon>
 <20120313160420.GA18307@moon>
 <20120314014106.GI19584@count0.beaverton.ibm.com>
 <20120314054728.GA2778@moon>
 <20120314222108.GJ19584@count0.beaverton.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120314222108.GJ19584@count0.beaverton.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 14, 2012 at 03:21:08PM -0700, Matt Helsley wrote:
...
> 
> OK, sorry I must have missed that portion of the discussion. It all looks
> good to me.
> 

Thanks a lot for all your comments, Matt!
Can I add your Reviewed-by or something
on the last version of the patch?

(this one which looks good to Oleg
 https://lkml.org/lkml/2012/3/13/437)

so I would gather these two patches
together and will resend them out
again (you'll be CC'ed so you'll see).

	Cyrill
