Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752531Ab2E1XWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 May 2012 19:22:55 -0400
Received: from mail-pz0-f46.google.com ([209.85.210.46]:50716 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751403Ab2E1XWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 May 2012 19:22:54 -0400
Date: Tue, 29 May 2012 08:22:46 +0900
From: Tejun Heo <tj@kernel.org>
To: Kent Overstreet <koverstreet@google.com>
Cc: linux-kernel@vger.kernel.org, linux-bcache@vger.kernel.org,
        axboe@kernel.dk, paul.gortmaker@windriver.com
Subject: Re: [PATCH 0/3] Generic rb tree code
Message-ID: <20120528232246.GC20954@dhcp-172-17-108-109.mtv.corp.google.com>
References: <1337979461-19654-1-git-send-email-koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1337979461-19654-1-git-send-email-koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 25, 2012 at 01:57:38PM -0700, Kent Overstreet wrote:
> Right now, users of the rb tree code have to open code their own search and
> insert functions. This provides generic versions that you pass a comparison
> function to.
> 
> I highly doubt the extra function calls are going to have a measurable
> performance impact in practice - the pointer chasing is going to dominate. I
> did provide inline versions just in case, though - it's modelled after the
> spinlock code.

Modeled after spinlock code how?  AFAICS, spinlock code doesn't
present inline and !inline versions to users.  All the current users
are inline anyway, why not just provide inlined versions and worry
about whether inlining is beneifical in a separate patch?

Thanks.

-- 
tejun
