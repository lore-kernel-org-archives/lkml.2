Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758499Ab2FTXS1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Jun 2012 19:18:27 -0400
Received: from cantor2.suse.de ([195.135.220.15]:46952 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754759Ab2FTXS0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Jun 2012 19:18:26 -0400
Date: Wed, 20 Jun 2012 16:18:23 -0700
From: Mark Fasheh <mfasheh@suse.de>
To: Luis Henriques <luis.henriques@canonical.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Bret Towe <magnade@gmail.com>,
        linux-kernel@vger.kernel.org, ocfs2-devel@oss.oracle.com,
        jlbec@evilplan.org, sunil.mushran@oracle.com
Subject: Re: [PATCH] ocfs2: Fix NULL pointer dereferrence in __ocfs2_change_file_space
Message-ID: <20120620231823.GE17950@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.de>
References: <20120620145659.a5fff5f6.akpm@linux-foundation.org> <1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1340231684-1667-1-git-send-email-luis.henriques@canonical.com>
Organization: SUSE Labs
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This should've been upstream a while ago  :/

On Wed, Jun 20, 2012 at 11:34:44PM +0100, Luis Henriques wrote:
> As ocfs2_fallocate() will invoke __ocfs2_change_file_space() with a NULL
> as the first parameter (file), it may trigger a NULL pointer dereferrence
> due to a missing check.  See http://bugs.launchpad.net/bugs/1006012.
> 
> Signed-off-by: Luis Henriques <luis.henriques@canonical.com>

Signed-off-by: Mark Fasheh <mfasheh@suse.de>
	--Mark

--
Mark Fasheh
