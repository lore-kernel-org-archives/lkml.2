Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757916Ab0EESkD (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 14:40:03 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:46451 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1757708Ab0EESj6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 14:39:58 -0400
Date: Wed, 5 May 2010 19:39:54 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Alan Stern <stern@rowland.harvard.edu>, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505183954.GF7139@rakim.wolfsonmicro.main>
References: <1272667021-21312-1-git-send-email-arve@android.com>
 <201005042223.41370.rjw@sisk.pl>
 <20100504235644.GA5231@opensource.wolfsonmicro.com>
 <201005050222.31038.rjw@sisk.pl>
 <20100505110630.GA5754@opensource.wolfsonmicro.com>
 <j2xa55d774e1005050500ocaa77b0di8e9eb58ce9c82d58@mail.gmail.com>
 <20100505135621.GB7139@rakim.wolfsonmicro.main>
 <20100505173337.GA1671@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505173337.GA1671@srcf.ucam.org>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 06:33:37PM +0100, Matthew Garrett wrote:

> We seem to have ended up managing most of our PM infrastructure 
> iteratively. If the concern is more about best practices than intrinsic 
> incompatibilities, I'd lean towards us being better off merging this now 
> and then working things out over the next few releases as we get a 
> better understanding of the implications. The main thing that we have to 
> get right in the short term is the userspace API - everything else is 
> easier to fix up as we go along.

Right, the big issue for me is that there's likely to be some form of
userspace API visible for controlling this.  I think I can keep it
mostly in-kernel for audio (by providing new APIs to mark some inputs
and outputs as being live during suspend) but need to check.
