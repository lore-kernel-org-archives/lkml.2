Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934881Ab0EEQ1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 12:27:08 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:33027 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932922Ab0EEQ1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 12:27:06 -0400
Date: Wed, 5 May 2010 17:27:00 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Brian Swetland <swetland@google.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505162700.GE7139@rakim.wolfsonmicro.main>
References: <20100504235644.GA5231@opensource.wolfsonmicro.com>
 <Pine.LNX.4.44L0.1005051133210.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005051133210.1885-100000@iolanthe.rowland.org>
X-Cookie: Yow!  I threw up on my window!
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 11:35:56AM -0400, Alan Stern wrote:
> On Wed, 5 May 2010, Mark Brown wrote:

> > In other words, the issue is that we run into situations where we need
> > an element of suspend control to go along with the opportunistic suspend
> > in order to allow some elements to be kept running - since suspend
> > blocking is taken suspend suppression seems like a reasonable term.

> Android must already include some solution to this problem.  Why not 
> use that solution more generally?

Not so much; at least for audio it's being handled with platform
specific bodges as far as I've seen so far.  If there had been a
standard way of doing this I'd have expected to see it in this patch
series.  The Google systems all use Qualcomm chipsets which aren't
affected by this since the audio CODEC is hidden from Linux and none of
the audio actually uses ALSA at all in the BSPs I looked at.

It's entirely possible I'm missing something here, everything I know has
come from either talking to users or trawling code on the internet.
