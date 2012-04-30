Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755611Ab2D3OaJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Apr 2012 10:30:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:45710 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754861Ab2D3OaH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Apr 2012 10:30:07 -0400
Date: Mon, 30 Apr 2012 15:30:04 +0100
From: Mel Gorman <mgorman@suse.de>
To: Jan Kara <jack@suse.cz>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-man@vger.kernel.org,
        linux-mm@kvack.org, Jeff Moyer <jmoyer@redhat.com>
Subject: Re: [PATCH] Describe race of direct read and fork for unaligned
 buffers
Message-ID: <20120430143004.GP9226@suse.de>
References: <1335778207-6511-1-git-send-email-jack@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1335778207-6511-1-git-send-email-jack@suse.cz>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 30, 2012 at 11:30:07AM +0200, Jan Kara wrote:
> This is a long standing problem (or a surprising feature) in our implementation
> of get_user_pages() (used by direct IO). Since several attempts to fix it
> failed (e.g.
> http://linux.derkeiler.com/Mailing-Lists/Kernel/2009-04/msg06542.html, or
> http://lkml.indiana.edu/hypermail/linux/kernel/0903.1/01498.html refused in
> http://comments.gmane.org/gmane.linux.kernel.mm/31569) and it's not completely
> clear whether we really want to fix it given the costs, let's at least document
> it.
> 
> CC: mgorman@suse.de
> CC: Jeff Moyer <jmoyer@redhat.com>
> Signed-off-by: Jan Kara <jack@suse.cz>

Acked-by: Mel Gorman <mgorman@suse.de>

-- 
Mel Gorman
SUSE Labs
