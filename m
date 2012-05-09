Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760451Ab2EIS4M (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 14:56:12 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:55474 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758214Ab2EIS4K (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 14:56:10 -0400
Date: Wed, 9 May 2012 20:56:08 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: Suresh Siddha <suresh.b.siddha@intel.com>
Cc: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joerg.roedel@amd.com,
        paul.gortmaker@windriver.com
Subject: Re: [PATCH 1/2] kconfig: change config_enabled() to accept X
	instead of CONFIG_X
Message-ID: <20120509185608.GA13435@merkur.ravnborg.org>
References: <20120509093001.GD8585@gmail.com> <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, May 09, 2012 at 11:46:35AM -0700, Suresh Siddha wrote:
> change config_enabled() to use it as config_enabled(SMP) instead of
> config_enabled(CONFIG_SMP).

You are breaking all existing users.
And CONFIG_ was included to allow better grepability.

If you insist on having a CONFIG less variant
introduce a new variant for this.

	Sam
