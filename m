Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753867Ab2DBWdL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Apr 2012 18:33:11 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:44875 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753828Ab2DBWdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Apr 2012 18:33:09 -0400
Date: Mon, 2 Apr 2012 15:33:04 -0700
From: Tejun Heo <tj@kernel.org>
To: Jens Axboe <axboe@kernel.dk>
Cc: vgoyal@redhat.com, ctalbott@google.com, rni@google.com,
        linux-kernel@vger.kernel.org, cgroups@vger.kernel.org,
        containers@lists.linux-foundation.org
Subject: Re: [PATCHSET] block: modularize blkcg config and stat file
 handling
Message-ID: <20120402223304.GC21017@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1332975091-10950-1-git-send-email-tj@kernel.org>
 <4F741AED.6090901@kernel.dk>
 <20120402200233.GB17175@dhcp-172-17-108-109.mtv.corp.google.com>
 <4F7A1F52.50706@kernel.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4F7A1F52.50706@kernel.dk>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 02, 2012 at 02:51:14PM -0700, Jens Axboe wrote:
> > Other than $SUBJ update on the eigth patch from "blkcg:
> > blkg_conf_prep()" to "blkcg: simplify blkg_conf_prep()", the patchset
> > can be applied as-is on top of the current block/for-3.5/core.
> 
> Alright, pulled in as well. I'm glad we pushed this to 3.5 :-)

Yeah, I'm fairly sure if we had shoved this through 3.4, we would be
having another round of f**k you's from Linus.

I'll probably send one or two more rounds of patches to clean up
in-place blkg updates and make active policy selection per
request_queue, but I'm glad to finally have the end in sight.

Thanks.

-- 
tejun
