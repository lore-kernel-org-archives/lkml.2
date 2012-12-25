Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754145Ab2LYSak (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 13:30:40 -0500
Received: from li9-11.members.linode.com ([67.18.176.11]:40281 "EHLO
	imap.thunk.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754058Ab2LYSai (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 13:30:38 -0500
Date: Tue, 25 Dec 2012 13:30:32 -0500
From: "Theodore Ts'o" <tytso@mit.edu>
To: Andy Lutomirski <luto@amacapital.net>
Cc: Jan Kara <jack@suse.cz>, linux-kernel@vger.kernel.org,
        linux-ext4@vger.kernel.org
Subject: Re: [PATCH] ext4: Fix an incorrect comment about i_mutex
Message-ID: <20121225183032.GB5318@thunk.org>
Mail-Followup-To: Theodore Ts'o <tytso@mit.edu>,
	Andy Lutomirski <luto@amacapital.net>, Jan Kara <jack@suse.cz>,
	linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
References: <1323a2735a9106cf0fa1a6ffee938ce432aa085d.1356117764.git.luto@amacapital.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1323a2735a9106cf0fa1a6ffee938ce432aa085d.1356117764.git.luto@amacapital.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: tytso@thunk.org
X-SA-Exim-Scanned: No (on imap.thunk.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 21, 2012 at 11:24:58AM -0800, Andy Lutomirski wrote:
> i_mutex is not held when ->sync_file is called.
> 
> Reviewed-by: Jan Kara <jack@suse.cz>
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

Thanks, applied.

						- Ted
