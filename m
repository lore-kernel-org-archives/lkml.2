Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757770Ab0EEUJ6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 May 2010 16:09:58 -0400
Received: from cassiel.sirena.org.uk ([80.68.93.111]:43602 "EHLO
	cassiel.sirena.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755557Ab0EEUJx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 May 2010 16:09:53 -0400
Date: Wed, 5 May 2010 21:09:41 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Matthew Garrett <mjg@redhat.com>
Cc: Alan Stern <stern@rowland.harvard.edu>,
       Brian Swetland <swetland@google.com>, "Rafael J. Wysocki" <rjw@sisk.pl>,
       Kevin Hilman <khilman@deeprootsystems.com>,
       Arve Hj?nnev?g <arve@android.com>, linux-pm@lists.linux-foundation.org,
       linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
       Oleg Nesterov <oleg@redhat.com>, Paul Walmsley <paul@pwsan.com>,
       magnus.damm@gmail.com, mark gross <mgross@linux.intel.com>,
       Arjan van de Ven <arjan@infradead.org>,
       Geoff Smith <geoffx.smith@intel.com>, rebecca@android.com
Subject: Re: [PATCH 0/8] Suspend block api (version 6)
Message-ID: <20100505200940.GD11441@sirena.org.uk>
References: <20100505185225.GA4411@srcf.ucam.org> <Pine.LNX.4.44L0.1005051511040.1885-100000@iolanthe.rowland.org> <20100505192208.GB5085@srcf.ucam.org> <20100505195249.GC11441@sirena.org.uk> <20100505200243.GA6266@srcf.ucam.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100505200243.GA6266@srcf.ucam.org>
X-Cookie: Do not overtax your powers.
User-Agent: Mutt/1.5.18 (2008-05-17)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: broonie@sirena.org.uk
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 05, 2010 at 09:02:43PM +0100, Matthew Garrett wrote:

> One thing that's been mentioned before is that some vendors can swap the 
> kernel much more easily than they can swap userspace, with the added 
> constraint that they have little control over the bootloader. So if 
> there's a userspace interface, it may well also be helpful to provide a 
> kernel hook to allow the platform setup code to configure things. But 

Oh, there's definitely going to be a platform-specific hook to configure
things.  The platform needs to specify how the devices that make up the
audio subsystem are interconnected on the board, and that's done in
kernel since it depends on the hardware and can potentially lead to
physical damage if done incorrectly.

> otherwise, I think that'd work for audio - the only question is whether 
> we need it to be more generic.

Agreed.
