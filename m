Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752749Ab0GJCMx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Jul 2010 22:12:53 -0400
Received: from h5.dl5rb.org.uk ([81.2.74.5]:53521 "EHLO h5.dl5rb.org.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752342Ab0GJCMv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Jul 2010 22:12:51 -0400
Date: Sat, 10 Jul 2010 03:12:27 +0100
From: Ralf Baechle <ralf@linux-mips.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-kernel@vger.kernel.org,
       linux-mips@linux-mips.org, Li Hong <lihong.hi@gmail.com>,
       Ingo Molnar <mingo@elte.hu>, Matt Fleming <matt@console-pimps.org>,
       Wu Zhangjin <wuzhangjin@gmail.com>
Subject: Re: [PATCH] tracing: recordmcount.pl: Fix $mcount_regex for MIPS.
Message-ID: <20100710021227.GA16134@linux-mips.org>
References: <1278712325-12050-1-git-send-email-ddaney@caviumnetworks.com>
 <1278721562.1537.169.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1278721562.1537.169.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 09, 2010 at 08:26:02PM -0400, Steven Rostedt wrote:

> I'd like to get an Acked-by from Ralf and Wu before pulling this.

I talked through this on irc with David and it is the right thing to do.

Acked-by: Ralf Baechle <ralf@linux-mips.org>

  Ralf
