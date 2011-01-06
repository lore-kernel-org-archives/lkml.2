Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753075Ab1AFKy1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 05:54:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:33936 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752992Ab1AFKy0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 05:54:26 -0500
Date: Thu, 6 Jan 2011 11:54:24 +0100
From: Jan Kara <jack@suse.cz>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Kernel Testers List <kernel-testers@vger.kernel.org>,
        Maciej Rutecki <maciej.rutecki@gmail.com>,
        Florian Mickler <florian@mickler.org>, Jan Kara <jack@suse.cz>,
        markus.gapp@gmx.net
Subject: Re: [Bug #21092] Kernel 2.6.36 Bug during quotaon on reiserfs
Message-ID: <20110106105424.GC4641@quack.suse.cz>
References: <odW4v9b6arG.A.2bH.uE8GNB@chimera>
 <LbeBv-BNQpL.A.aM.5F8GNB@chimera>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <LbeBv-BNQpL.A.aM.5F8GNB@chimera>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

  Hi,

On Thu 30-12-10 00:21:21, Rafael J. Wysocki wrote:
> This message has been generated automatically as a part of a report
> of regressions introduced between 2.6.35 and 2.6.36.
> 
> The following bug entry is on the current list of known regressions
> introduced between 2.6.35 and 2.6.36.  Please verify if it still should
> be listed and let the tracking team know (either way).
> 
> 
> Bug-Entry	: http://bugzilla.kernel.org/show_bug.cgi?id=21092
> Subject		: Kernel 2.6.36 Bug during quotaon on reiserfs
> Submitter	:  <markus.gapp@gmx.net>
> Date		: 2010-10-24 16:57 (67 days old)
> Handled-By	: Jan Kara <jack@suse.cz>
> Patch		: https://bugzilla.kernel.org/attachment.cgi?id=35292
  As far as I know, the problem has been fixed by commit
da905873effecd1c0166e578bc4b5006f041b18b in the end.

								Honza
-- 
Jan Kara <jack@suse.cz>
SUSE Labs, CR
