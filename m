Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751411Ab2KXNGK (ORCPT <rfc822;w@1wt.eu>);
	Sat, 24 Nov 2012 08:06:10 -0500
Received: from cantor2.suse.de ([195.135.220.15]:53039 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab2KXNGI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 24 Nov 2012 08:06:08 -0500
Date: Sat, 24 Nov 2012 13:06:05 +0000
From: Mel Gorman <mgorman@suse.de>
To: Hillf Danton <dhillf@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/3] balancenuma: free new thp if fail to isolate the old
Message-ID: <20121124130605.GB8218@suse.de>
References: <CAJd=RBAn-wASi7vHw2+hoU5zGE8x0pn-T_sPbtTF_HS5ha10NQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <CAJd=RBAn-wASi7vHw2+hoU5zGE8x0pn-T_sPbtTF_HS5ha10NQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Nov 24, 2012 at 12:18:51PM +0800, Hillf Danton wrote:
> Free newly allocated thp if fail to isolate the old.
> 
> Signed-off-by: Hillf Danton <dhillf@gmail.com>

Thanks!

-- 
Mel Gorman
SUSE Labs
