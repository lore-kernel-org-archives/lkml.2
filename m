Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756012Ab0JSQjP (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 12:39:15 -0400
Received: from isilmar-3.linta.de ([188.40.101.200]:60790 "EHLO linta.de"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755822Ab0JSQjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 12:39:12 -0400
Date: Tue, 19 Oct 2010 18:24:07 +0200
From: Helmut Grohne <helmut@subdivi.de>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Andrew Morton <akpm@linux-foundation.org>, Mel Gorman <mel@csn.ul.ie>,
        pacman@kosh.dhis.org, linux-mm@kvack.org,
        LKML <linux-kernel@vger.kernel.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: PROBLEM: memory corrupting bug, bisected to 6dda9d55
Message-ID: <20101019162407.GB10148@alf.mars>
Mail-Followup-To: Helmut Grohne <helmut@subdivi.de>,
	Thomas Gleixner <tglx@linutronix.de>,
	Andrew Morton <akpm@linux-foundation.org>,
	Mel Gorman <mel@csn.ul.ie>, pacman@kosh.dhis.org,
	linux-mm@kvack.org, LKML <linux-kernel@vger.kernel.org>,
	linuxppc-dev@lists.ozlabs.org
References: <20101013144044.GS30667@csn.ul.ie>
 <20101013175205.21187.qmail@kosh.dhis.org>
 <20101018113331.GB30667@csn.ul.ie>
 <20101018123750.ef7d6d48.akpm@linux-foundation.org>
 <alpine.LFD.2.00.1010182342490.6815@localhost6.localdomain6>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LFD.2.00.1010182342490.6815@localhost6.localdomain6>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 18, 2010 at 11:55:44PM +0200, Thomas Gleixner wrote:
> I might be completely one off as usual, but this thing reminds me of a
> bug I stared at yesterday night:

This problem is completely unrelated. My problem was caused by using
binutils-gold.

Helmut
