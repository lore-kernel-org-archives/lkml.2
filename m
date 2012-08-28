Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab2H1Ogh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Aug 2012 10:36:37 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:62320 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807Ab2H1Ogf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Aug 2012 10:36:35 -0400
Date: Tue, 28 Aug 2012 07:35:53 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: "Richard W.M. Jones" <rjones@redhat.com>
cc: Jeff Moyer <jmoyer@redhat.com>, Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Jens Axboe <jaxboe@fusionio.com>,
        Torsten Hilbrich <torsten.hilbrich@secunet.com>,
        Josh Boyer <jwboyer@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] block: replace __getblk_slow misfix by grow_dev_page
 fix
In-Reply-To: <20120828111452.GH5234@rhmail.home.annexia.org>
Message-ID: <alpine.LSU.2.00.1208280732140.7694@eggly.anvils>
References: <alpine.LSU.2.00.1208211826270.2488@eggly.anvils> <20120822115243.GU1448@rhmail.home.annexia.org> <alpine.LSU.2.00.1208222143440.1917@eggly.anvils> <20120828111452.GH5234@rhmail.home.annexia.org>
User-Agent: Alpine 2.00 (LSU 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 28 Aug 2012, Richard W.M. Jones wrote:
> On Wed, Aug 22, 2012 at 09:56:12PM -0700, Hugh Dickins wrote:
> > [PATCH] block: replace __getblk_slow misfix by grow_dev_page fix
> 
> I noticed this (second version) went upstream already.  Nevertheless I
> tested it today and it doesn't cause a regression of RHBZ#835019.

Thank you for testing and confirming, Rich.
Once Jeff had tested it, we felt safe to go ahead while you were off.

Hugh
