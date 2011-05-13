Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756594Ab1EMSRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 May 2011 14:17:41 -0400
Received: from cantor.suse.de ([195.135.220.2]:51158 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751665Ab1EMSRk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 May 2011 14:17:40 -0400
Date: Fri, 13 May 2011 11:17:38 -0700
From: Mark Fasheh <mfasheh@suse.com>
To: Amerigo Wang <amwang@redhat.com>, ocfs2-devel@oss.oracle.com,
        Randy Dunlap <rdunlap@xenotime.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [Patch] ocfs2: remove the /sys/o2cb symlink
Message-ID: <20110513181738.GK17822@wotan.suse.de>
Reply-To: Mark Fasheh <mfasheh@suse.com>
References: <1304256856-4744-1-git-send-email-amwang@redhat.com> <20110513180607.GA2349@noexit.corp.google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20110513180607.GA2349@noexit.corp.google.com>
Organization: SUSE Labs, Novell, Inc
User-Agent: Mutt/1.5.9i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 13, 2011 at 11:06:12AM -0700, Joel Becker wrote:
> On Sun, May 01, 2011 at 09:34:16PM +0800, Amerigo Wang wrote:
> > It is obsoleted since Dec 2005.
> 
> 	Actually, we moved it in 2008.  Sunil, Mark, do we have new
> enough tools everywhere?  Looks like ocfs2-tools 1.4 has it.  I'm going
> to take this unless you object.

Fine with me too, it's past time we did this.
	--Mark

--
Mark Fasheh
