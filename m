Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757497Ab1E0Xdj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 May 2011 19:33:39 -0400
Received: from zeniv.linux.org.uk ([195.92.253.2]:56685 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752263Ab1E0Xdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 May 2011 19:33:38 -0400
Date: Fri, 27 May 2011 16:33:31 -0700
From: Joel Becker <jlbec@evilplan.org>
To: Steven Whitehouse <swhiteho@redhat.com>
Cc: Dan Magenheimer <dan.magenheimer@oracle.com>, linux-kernel@vger.kernel.org,
        sunil.mushran@oracle.com
Subject: Re: Cleancache and shared filesystems
Message-ID: <20110527233331.GC30232@noexit.corp.google.com>
Mail-Followup-To: Steven Whitehouse <swhiteho@redhat.com>,
	Dan Magenheimer <dan.magenheimer@oracle.com>,
	linux-kernel@vger.kernel.org, sunil.mushran@oracle.com
References: <1306504300.2857.14.camel@menhir>
 <6f0e746a-d3d1-4708-9e16-3d02ddeab824@default>
 <1306513179.2857.38.camel@menhir>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1306513179.2857.38.camel@menhir>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 27, 2011 at 05:19:39PM +0100, Steven Whitehouse wrote:
> +	if (ls->ls_ops == &gfs2_dlm_ops) {
> +		if (gfs2_uuid_valid(sb->s_uuid))
> +			cleancache_init_shared_fs(sb->s_uuid, sb);
> +	} else {
> +		cleancache_init_fs(sb);
> +	}

Hey Dan,
	Steven makes a good point here.  ocfs2 could also take advantage
of local filesystem behavior when running in local mode.

Joel

-- 

Life's Little Instruction Book #69

	"Whistle"

			http://www.jlbec.org/
			jlbec@evilplan.org
