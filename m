Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab0GLWju (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jul 2010 18:39:50 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:26257 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755479Ab0GLWjt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jul 2010 18:39:49 -0400
Date: Mon, 12 Jul 2010 15:37:31 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: Joe Perches <joe@perches.com>
Cc: Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
        Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
Subject: Re: [PATCH 27/36] fs/ocfs2: Remove unnecessary casts of
 private_data
Message-ID: <20100712223731.GH12179@mail.oracle.com>
Mail-Followup-To: Joe Perches <joe@perches.com>,
	Jiri Kosina <trivial@kernel.org>, linux-kernel@vger.kernel.org,
	Mark Fasheh <mfasheh@suse.com>, ocfs2-devel@oss.oracle.com
References: <cover.1278967120.git.joe@perches.com>
 <c75b92bbfb63964703ae99733f39696af4550f07.1278967121.git.joe@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c75b92bbfb63964703ae99733f39696af4550f07.1278967121.git.joe@perches.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Source-IP: acsmt353.oracle.com [141.146.40.153]
X-Auth-Type: Internal IP
X-CT-RefId: str=0001.0A0B0208.4C3B996D.01E2:SCFMA4539814,ss=1,fgs=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 12, 2010 at 01:50:19PM -0700, Joe Perches wrote:
> Signed-off-by: Joe Perches <joe@perches.com>
> ---
>  fs/ocfs2/dlm/dlmdebug.c |    6 +++---
>  fs/ocfs2/dlmfs/dlmfs.c  |    3 +--
>  fs/ocfs2/dlmglue.c      |    4 ++--
>  3 files changed, 6 insertions(+), 7 deletions(-)

Acked-by: Joel Becker <joel.becker@oracle.com>

Btw, how hilarious is the comment for private_data?

Joel

-- 

A good programming language should have features that make the
kind of people who use the phrase "software engineering" shake
their heads disapprovingly.
	- Paul Graham

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
