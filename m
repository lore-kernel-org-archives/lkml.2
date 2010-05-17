Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755309Ab0EQSyt (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 May 2010 14:54:49 -0400
Received: from mail-pw0-f46.google.com ([209.85.160.46]:60141 "EHLO
	mail-pw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752266Ab0EQSyr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 May 2010 14:54:47 -0400
To: James Bottomley <James.Bottomley@suse.de>
Cc: me@felipebalbi.com, Alan Stern <stern@rowland.harvard.edu>,
       linux-omap@vger.kernel.org, "Theodore Ts'o" <tytso@mit.edu>,
       Geoff Smith <geoffx.smith@intel.com>,
       Brian Swetland <swetland@google.com>,
       Kernel development list <linux-kernel@vger.kernel.org>,
       Oleg Nesterov <oleg@redhat.com>,
       Mark Brown <broonie@opensource.wolfsonmicro.com>,
       Tejun Heo <tj@kernel.org>,
       Linux-pm mailing list <linux-pm@lists.linux-foundation.org>,
       Arjan van de Ven <arjan@infradead.org>,
       Liam Girdwood <lrg@slimlogic.co.uk>, Matthew Garrett <mjg@redhat.com>
Subject: Re: [linux-pm] [PATCH 0/8] Suspend block api (version 6)
References: <Pine.LNX.4.44L0.1005151716180.24645-100000@netrider.rowland.org>
	<87hbm6cz90.fsf@deeprootsystems.com>
	<1274115885.4418.59.camel@mulgrave.site>
	<20100517174647.GA11512@gandalf>
	<1274119179.4418.68.camel@mulgrave.site>
From: Kevin Hilman <khilman@deeprootsystems.com>
Organization: Deep Root Systems, LLC
Date: Mon, 17 May 2010 11:54:40 -0700
In-Reply-To: <1274119179.4418.68.camel@mulgrave.site> (James Bottomley's message of "Mon\, 17 May 2010 13\:59\:39 -0400")
Message-ID: <87k4r24avj.fsf@deeprootsystems.com>
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.2 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

James Bottomley <James.Bottomley@suse.de> writes:

> The technical reason for wanting suspend blockers (as has been stated
> more times than I can be bothered to go back and count) is that no-one
> can currently produce a working model for race free kernel to user work
> handoff

At least I've never heard this technial reason stated so succinctly.  It's
not in the changelogs or in the Documentation file included.

The way I undertand things, today's mainline kernel has a race-free
kernel-to-user work handoff already.

The possibility of races is introduced by the opportunistic suspend
feature itself (patch 1.)  The use of suspend blockers later in the
series is needed to avoid the potential races introduced by
opportunistic suspend.

Kevin
