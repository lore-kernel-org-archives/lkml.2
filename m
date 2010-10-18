Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932471Ab0JRWQ2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Oct 2010 18:16:28 -0400
Received: from rcsinet10.oracle.com ([148.87.113.121]:32611 "EHLO
	rcsinet10.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755444Ab0JRWQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Oct 2010 18:16:27 -0400
Date: Mon, 18 Oct 2010 15:15:28 -0700
From: Joel Becker <Joel.Becker@oracle.com>
To: "J.H." <warthog9@kernel.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>
Subject: Re: More issues found on kernel.org
Message-ID: <20101018221528.GC31479@mail.oracle.com>
Mail-Followup-To: "J.H." <warthog9@kernel.org>,
	linux-kernel <linux-kernel@vger.kernel.org>
References: <4CBC9CC7.7050204@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CBC9CC7.7050204@kernel.org>
X-Burt-Line: Trees are cool.
X-Red-Smith: Ninety feet between bases is perhaps as close as man has ever
 come to perfection.
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 12:15:19PM -0700, J.H. wrote:
> Not that the current discussion on IMA, and the recent problems found
> with XFS were enough, I've started seeing, rather regularly, what I've
> reported in bugzilla
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=20702
> 
> It looks like a double free is happening somewhere, and the issue
> *SEEMS* to be limited to the dynamic web boxes (bugzilla, wiki's, etc)
> and those are the only boxes I have running drbd and ocfs2.

	Obviously with no ocfs2 in the stack traces, it's hard to say
anything from that perspective.  Do you have any idea what file snmpd is
closing?

Joel

-- 

"I'm so tired of being tired,
 Sure as night will follow day.
 Most things I worry about
 Never happen anyway."

Joel Becker
Consulting Software Developer
Oracle
E-mail: joel.becker@oracle.com
Phone: (650) 506-8127
