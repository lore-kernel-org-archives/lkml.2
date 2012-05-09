Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760941Ab2EIUFb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 16:05:31 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:26163 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab2EIUFa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 16:05:30 -0400
Date: Wed, 9 May 2012 22:05:28 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joerg.roedel@amd.com,
        paul.gortmaker@windriver.com
Subject: Re: [PATCH 1/2] kconfig: change config_enabled() to accept X
	instead of CONFIG_X
Message-ID: <20120509200528.GA13687@merkur.ravnborg.org>
References: <20120509093001.GD8585@gmail.com> <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com> <20120509185608.GA13435@merkur.ravnborg.org> <1336591741.4634.4.camel@sbsiddha-desk.sc.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336591741.4634.4.camel@sbsiddha-desk.sc.intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 12:29:01PM -0700, Suresh Siddha wrote:
> On Wed, 2012-05-09 at 20:56 +0200, Sam Ravnborg wrote:
> > On Wed, May 09, 2012 at 11:46:35AM -0700, Suresh Siddha wrote:
> > > change config_enabled() to use it as config_enabled(SMP) instead of
> > > config_enabled(CONFIG_SMP).
> > 
> > You are breaking all existing users.
> 
> I checked the mainline and there were no users as far as I checked.
> Referring to some upcoming code? Just curious to see why I missed.
I assume that as it is in the tree someone has used it.
There are no users in the upstream kernel but I did not check -next.

	Sam
