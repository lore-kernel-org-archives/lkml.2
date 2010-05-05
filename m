Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758091Ab0EEV5Q (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 17:57:16 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:36599 "EHLO
	opensource2.wolfsonmicro.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753293Ab0EEV5O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 17:57:14 -0400
Date: Wed, 5 May 2010 22:57:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: tytso@mit.edu, Matthew Garrett <mjg@redhat.com>,
       Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505215711.GA4838@opensource.wolfsonmicro.com>
References: <20100505185225.GA4411@srcf.ucam.org> <20100505195534.GD18762@thunk.org> <20100505202637.GH7139@rakim.wolfsonmicro.main> <201005052244.03225.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201005052244.03225.rjw@sisk.pl>
X-Cookie: Your aim is high and to the right.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 10:44:03PM +0200, Rafael J. Wysocki wrote:

> To me, the above may be summarized that in your opinion some components of
> the system will generally need to stay powered when it's suspended
> opportunistically, so we need an interface to specify which components they are.
> Is that correct?

Yes, though I think I'd be inclined to treat the problem orthogonally to
opportunistic suspend to allow more flexibility in use and since
treating it as part of opportunistic suspend would imply that there's
some meaningful difference between the end result of that and a manual
suspend which AIUI there isn't.
