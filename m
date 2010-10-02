Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862Ab0JBByZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Oct 2010 21:54:25 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:53922 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750706Ab0JBByY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Oct 2010 21:54:24 -0400
Date: Sat, 2 Oct 2010 10:54:17 +0900
From: Ralf Baechle <ralf@linux-mips.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: David Daney <ddaney@caviumnetworks.com>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, jbaron@redhat.com
Subject: Re: [PATCH] jump label: Add MIPS support.
Message-ID: <20101002015417.GA9360@linux-mips.org>
References: <1285697432-29244-1-git-send-email-ddaney@caviumnetworks.com>
 <1285969786.6750.19.camel@gandalf.stny.rr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1285969786.6750.19.camel@gandalf.stny.rr.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 01, 2010 at 05:49:46PM -0400, Steven Rostedt wrote:

> On Tue, 2010-09-28 at 11:10 -0700, David Daney wrote:
> > When in Rome...
> > 
> > In order not to be left behind, we add jump label support for MIPS.
> > 
> > Tested on 64-bit big endian (Octeon), and 32-bit little endian
> > (malta/qemu).
> > 
> > Signed-off-by: David Daney <ddaney@caviumnetworks.com>
> > Cc: Steven Rostedt <rostedt@goodmis.org>
> > Cc: Jason Baron <jbaron@redhat.com>
> > Cc: Ralf Baechle <ralf@linux-mips.org>
> 
> I can pull this into tip with an Acked-by from Ralf. He was just in
> Tokyo with me, and I don't know when he'll be available to do so.

Monday probably.  Just packing up for the airport.

  Ralf
