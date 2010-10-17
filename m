Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757111Ab0JQAtw (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Oct 2010 20:49:52 -0400
Received: from canuck.infradead.org ([134.117.69.58]:51459 "EHLO
	canuck.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757072Ab0JQAtv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Oct 2010 20:49:51 -0400
Date: Sat, 16 Oct 2010 20:49:45 -0400
From: Christoph Hellwig <hch@infradead.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Christoph Hellwig <hch@infradead.org>, Dave Chinner <david@fromorbit.com>,
        linux-kernel@vger.kernel.org, Mimi Zohar <zohar@us.ibm.com>,
        warthog9@kernel.org, kernel@lists.fedoraproject.org
Subject: Re: ima: use of radix tree cache indexing == massive waste of memory?
Message-ID: <20101017004945.GE1614@infradead.org>
References: <20101016065206.GO4681@dastard>
 <20101016192027.GA6883@infradead.org>
 <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ebc4973c-6c11-4397-b8b0-c212a27abce4@email.android.com>
User-Agent: Mutt/1.5.20 (2009-08-17)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by canuck.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 16, 2010 at 02:10:29PM -0700, H. Peter Anvin wrote:
> I'm confused ... what makes you think we are?  This might have been an unintentional misconfiguration...

I didn't mean to imply you enabled it intentionally.  In fact it looks
like the inode tracking in IMA is always on once it's compiled in, which
totally defeats the purpose of doing it's on iternal inode tracking
instead of bloating the inode what they originally proposed.  IMA really
needs a kernel parameter to only enabled this crap when people actually
use it.

And whoever turned it on in Fedora needs some serious wahcking.

