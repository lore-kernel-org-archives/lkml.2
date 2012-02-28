Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1030270Ab2B1UIB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Feb 2012 15:08:01 -0500
Received: from mail-pz0-f46.google.com ([209.85.210.46]:54611 "EHLO
	mail-pz0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757221Ab2B1UIA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Feb 2012 15:08:00 -0500
Authentication-Results: mr.google.com; spf=pass (google.com: domain of htejun@gmail.com designates 10.68.197.196 as permitted sender) smtp.mail=htejun@gmail.com; dkim=pass header.i=htejun@gmail.com
Date: Wed, 29 Feb 2012 05:07:53 +0900
From: Tejun Heo <tj@kernel.org>
To: Jiri Kosina <jkosina@suse.cz>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org, x86@kernel.org
Subject: Re: [PATCH] x86: memblock: move mem_hole_size() to .init
Message-ID: <20120228200753.GA3252@dhcp-172-17-108-109.mtv.corp.google.com>
References: <alpine.LNX.2.00.1202281614450.31150@pobox.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.00.1202281614450.31150@pobox.suse.cz>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 28, 2012 at 04:16:33PM +0100, Jiri Kosina wrote:
> mem_hole_size() is being called only from __init-marked functions, and as 
> such should be moved to .init section as well. Fixes this warning:
> 
> WARNING: vmlinux.o(.text+0x35511): Section mismatch in reference from the function mem_hole_size() to the function .init.text:absent_pages_in_range()
> 
> Signed-off-by: Jiri Kosina <jkosina@suse.cz>

Acked-by: Tejun Heo <tj@kernel.org>

Thanks.

-- 
tejun
