Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752267Ab1BDR6e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Feb 2011 12:58:34 -0500
Received: from zeniv.linux.org.uk ([195.92.253.2]:44200 "EHLO
	ZenIV.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751839Ab1BDR6d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Feb 2011 12:58:33 -0500
Date: Fri, 4 Feb 2011 09:58:01 -0800
From: Joel Becker <jlbec@evilplan.org>
To: dann.frazier@canonical.com
Cc: ocfs2-devel@oss.oracle.com, linux-kernel@vger.kernel.org
Subject: Re: [Ocfs2-devel] [PATCH] [ocfs2] Use a kobject instead of a kset
Message-ID: <20110204175751.GA21472@noexit>
Mail-Followup-To: dann.frazier@canonical.com, ocfs2-devel@oss.oracle.com,
	linux-kernel@vger.kernel.org
References: <1296837627-7416-1-git-send-email-dann.frazier@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1296837627-7416-1-git-send-email-dann.frazier@canonical.com>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 04, 2011 at 09:40:27AM -0700, dann.frazier@canonical.com wrote:
> From: dann frazier <dann.frazier@canonical.com>
> 
> We currently allocate a kset and add attributes to its internal kobject.
> However, Documentation/kobject.txt says only the kset code should manipulate
> this internal object, and we can get the same results by just creating our
> own kobject and avoiding a kset altogether.

	Hmm, is this actually valid?  I thought you had to be a kset to
have children.  Did this change at some point?

Joel

-- 

"Soap and education are not as sudden as a massacre, but they are more
 deadly in the long run."
	- Mark Twain


			http://www.jlbec.org/
			jlbec@evilplan.org
