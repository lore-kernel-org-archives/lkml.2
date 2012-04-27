Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755041Ab2D0GkV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Apr 2012 02:40:21 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:33338 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753184Ab2D0GkU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Apr 2012 02:40:20 -0400
Date: Fri, 27 Apr 2012 10:40:15 +0400
From: Cyrill Gorcunov <gorcunov@openvz.org>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, Kees Cook <keescook@chromium.org>
Subject: Re: linux-next: build warning after merge of the akpm tree
Message-ID: <20120427064015.GB1899@moon>
References: <20120427154420.1161da65e7bcc2322857e6b2@canb.auug.org.au>
 <20120427062218.GA1899@moon>
 <20120427162858.857ce3348830abe5bd0f9bb0@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120427162858.857ce3348830abe5bd0f9bb0@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Apr 27, 2012 at 04:28:58PM +1000, Stephen Rothwell wrote:
> Hi Cyrill,
> 
> > > Introduced by commit 5455a20be1a6 ("c/r: prctl: extend PR_SET_MM to set
> > > up more mm_struct entries").
> > 
> > Hi Stephen, thanks for report, have no idea how it happened, since
> > commit 5455a20be1a6 _has_ error = -EINVAL; line.
> 
> I blamed the wrong patch :-(
> 
> Commit 8f62e9e9ed ("c/r: prctl: simplify PR_SET_MM on mm::code/data
> assignment") removes the "error = -EINVAL".

Ah, could be. Please merge up the fix then (there were another patches
in Andrew's queue where this nit is fixed I think, but they are not yet
in -next). So this fix should do the trick. Thanks.

	Cyrill
