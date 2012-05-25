Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964797Ab2EYUB3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 May 2012 16:01:29 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:45967 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757674Ab2EYUB1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 May 2012 16:01:27 -0400
Date: Fri, 25 May 2012 13:01:23 -0700
From: Kent Overstreet <koverstreet@google.com>
To: Vivek Goyal <vgoyal@redhat.com>
Cc: Boaz Harrosh <bharrosh@panasas.com>, linux-kernel@vger.kernel.org,
        linux-bcache@vger.kernel.org, dm-devel@redhat.com,
        linux-fsdevel@vger.kernel.org, tj@kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de, drbd-dev@lists.linbit.com,
        mpatocka@redhat.com, sage@newdream.net, yehuda@hq.newdream.net
Subject: Re: [PATCH v2 09/14] block: Add an explicit bio flag for bios that
 own their bvec
Message-ID: <20120525200123.GA14196@google.com>
References: <1337817771-25038-1-git-send-email-koverstreet@google.com>
 <1337817771-25038-10-git-send-email-koverstreet@google.com>
 <4FBE687E.1030605@panasas.com>
 <20120524213158.GB22664@google.com>
 <20120525164914.GE3855@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120525164914.GE3855@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 12:49:14PM -0400, Vivek Goyal wrote:
> Even if you keep it as it is, I thought BIO_OWNS_BVEC probably communicates
> the idea better than BIO_HAS_BVEC.

Yeah, I'll make that change.
