Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933235Ab2EOQos (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 May 2012 12:44:48 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:33372 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932906Ab2EOQop (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 May 2012 12:44:45 -0400
Date: Tue, 15 May 2012 09:44:40 -0700
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, agk@redhat.com
Subject: Re: [Bcache v13 05/16] Export get_random_int()
Message-ID: <20120515164440.GB20827@google.com>
References: <cover.1336619038.git.koverstreet@google.com>
 <5278ad493eb3ad441b2091b4c119d741e47f5c97.1336619038.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5278ad493eb3ad441b2091b4c119d741e47f5c97.1336619038.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:09:13PM -0400, Kent Overstreet wrote:
> This is needed for bcache - it needs a fast source of random numbers for
> the throttling code in order to fuzz IO sizes, but the random numbers
> don't need to be any good (and it immediately converts it to a
> binomially distributed random number with popcount anyways).
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Please cc the maintainer (for other patches too).

Thanks.

-- 
tejun
