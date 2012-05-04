Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760415Ab2EDW1S (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 May 2012 18:27:18 -0400
Received: from cantor2.suse.de ([195.135.220.15]:59142 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757796Ab2EDW1Q (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 May 2012 18:27:16 -0400
Date: Sat, 5 May 2012 00:24:42 +0200
From: Michal Marek <mmarek@suse.cz>
To: "Eric W. Biederman" <ebiederm@xmission.com>
Cc: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        Arnaud Lacombe <lacombar@gmail.com>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kbuild: Add error handling to KCONFIG_ALL_CONFIG
Message-ID: <20120504222442.GB13701@sepie.suse.cz>
References: <m1aa22rllb.fsf@fess.ebiederm.org>
 <4F96705C.5030901@suse.cz>
 <m1aa21nxzg.fsf_-_@fess.ebiederm.org>
 <20120424123305.GA30068@sepie.suse.cz>
 <m1k415mgrv.fsf@fess.ebiederm.org>
 <4F96AC7F.6080603@suse.cz>
 <m1wr52dgff.fsf@fess.ebiederm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <m1wr52dgff.fsf@fess.ebiederm.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 26, 2012 at 01:51:32AM -0700, Eric W. Biederman wrote:
> 
> - Only try to read the file specified if KCONFIG_ALL_CONFIG is set to
>   something other than the empty string or "1".
> 
> - Don't use stat to check the name passed to conf_read_simple so that
>   zconf_fopen can find the file in the current directory or in SRCTREE
>   removing a extremely source of confusing failure, where KCONFIG_ALL_CONFIG
>   was not interpreted with respect to the directory make was called in.
> 
> - If conf_read_simple fails complain clearly and stop processing.
>   Allowing the simple debugging of typos.
> 
> - Clearly document the behavior so it is clear to users which
>   values are treated as flags and which values are treated as
>   filenames.

Thanks, applied to kbuild.git#kconfig.

Michal
