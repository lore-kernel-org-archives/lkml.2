Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758135Ab0EETWj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 15:22:39 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:41355 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757019Ab0EETWh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 15:22:37 -0400
Date: Wed, 5 May 2010 20:22:08 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve =?iso-8859-1?B?SGr4bm5lduVn?= <arve@android.com>,
       linux-pm@lists.linux-foundation.org, linux-kernel@vger.kernel.org,
       Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
       Paul Walmsley <paul@pwsan.com>, magnus.damm@gmail.com,
       mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505192208.GB5085@srcf.ucam.org>
References: <20100505185225.GA4411@srcf.ucam.org> <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 03:13:52PM -0400, Alan Stern wrote:

> Should the audio driver be smart enough to know that the codec needs to
> remain powered up during every opportunistic suspend?
> 
> Or only during opportunistic suspends while a call is in progress?  

The latter is obviously preferable...

> Does it know when a call is in progress?

Perhaps you could infer that from the audio routing setup? I don't know 
enough about embedded codecs.

> Does Android use forced suspends?

No.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
