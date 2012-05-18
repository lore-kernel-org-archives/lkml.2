Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757868Ab2ERP5h (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 11:57:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:37876 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab2ERP5e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 11:57:34 -0400
Date: Fri, 18 May 2012 08:57:29 -0700
From: Tejun Heo <tj@kernel.org>
To: koverstreet@google.com
Cc: linux-bcache@vger.kernel.org, linux-kernel@vger.kernel.org,
        dm-devel@redhat.com, linux-fsdevel@vger.kernel.org, axboe@kernel.dk,
        agk@redhat.com, neilb@suse.de
Subject: Re: [PATCH 02/13] dm: kill dm_rq_bio_destructor
Message-ID: <20120518155729.GB19388@google.com>
References: <cover.1337308722.git.koverstreet@google.com>
 <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f07bc0f57562d98078e0f4c507cae165aa159e7c.1337308722.git.koverstreet@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 10:59:49PM -0400, koverstreet@google.com wrote:
> From: Kent Overstreet <koverstreet@google.com>
> 
> Signed-off-by: Kent Overstreet <koverstreet@google.com>

Please explain why this is done and how it's safe.  Alasdair / dm
folks, can you please ack this?

Thanks.

-- 
tejun
