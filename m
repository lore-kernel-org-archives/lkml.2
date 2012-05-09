Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760839Ab2EITZe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 May 2012 15:25:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:5293 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754296Ab2EITZd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 May 2012 15:25:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.71,315,1320652800"; 
   d="scan'208";a="98225916"
Subject: Re: [PATCH 1/2] kconfig: change config_enabled() to accept X
 instead of CONFIG_X
From: Suresh Siddha <suresh.b.siddha@intel.com>
Reply-To: Suresh Siddha <suresh.b.siddha@intel.com>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: mingo@kernel.org, tglx@linutronix.de, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, joerg.roedel@amd.com,
        paul.gortmaker@windriver.com
Date: Wed, 09 May 2012 12:29:01 -0700
In-Reply-To: <20120509185608.GA13435@merkur.ravnborg.org>
References: <20120509093001.GD8585@gmail.com>
	 <1336589196-14498-1-git-send-email-suresh.b.siddha@intel.com>
	 <20120509185608.GA13435@merkur.ravnborg.org>
Organization: Intel Corp
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.0.3 (3.0.3-1.fc15) 
Content-Transfer-Encoding: 7bit
Message-ID: <1336591741.4634.4.camel@sbsiddha-desk.sc.intel.com>
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-09 at 20:56 +0200, Sam Ravnborg wrote:
> On Wed, May 09, 2012 at 11:46:35AM -0700, Suresh Siddha wrote:
> > change config_enabled() to use it as config_enabled(SMP) instead of
> > config_enabled(CONFIG_SMP).
> 
> You are breaking all existing users.

I checked the mainline and there were no users as far as I checked.
Referring to some upcoming code? Just curious to see why I missed.

> And CONFIG_ was included to allow better grepability.

Ok.

> If you insist on having a CONFIG less variant
> introduce a new variant for this.

I will drop this for now.

thanks,
suresh

