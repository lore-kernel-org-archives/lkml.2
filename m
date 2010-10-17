Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757170Ab0JQBN4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 21:13:56 -0400
Received: from canuck.infradead.org ([134.117.69.58]:46020 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757113Ab0JQBNz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 21:13:55 -0400
Date: Sat, 16 Oct 2010 21:13:50 -0400
From: Christoph Hellwig <hch@infradead.org>
To: Kyle McMartin <kyle@mcmartin.ca>
Cc: Christoph Hellwig <hch@infradead.org>, "H. Peter Anvin" <hpa@zytor.com>,
        kernel@lists.fedoraproject.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, eparis@redhat.com
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101017011350.GA2838@infradead.org>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
 <20101017004945.GE1614@infradead.org>
 <20101017010917.GB8332@bombadil.infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20101017010917.GB8332@bombadil.infradead.org>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 09:09:17PM -0400, Kyle McMartin wrote:
> The Kconfig description sounds generally useful to me. If it's bloated
> crap, how did it get merged?

Just like all the other crap.  It's been made pretty clear that "no"
generally is not an answer for a merge request.  Just bikeshedding over
whitespace or maintainer files entries for a couple month of delay is
fine.

