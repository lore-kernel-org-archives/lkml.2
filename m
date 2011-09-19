Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756328Ab1ISTe7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Sep 2011 15:34:59 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:44587 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755934Ab1ISTe5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Sep 2011 15:34:57 -0400
Subject: Re: [PATCH 1/2] kconfig: Add make olddefconfig
From: John Stultz <john.stultz@linaro.org>
To: Sam Ravnborg <sam@ravnborg.org>
Cc: lkml <linux-kernel@vger.kernel.org>, gthelen@google.com, tartler@cs.fau.de,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
In-Reply-To: <20110917060625.GA27128@merkur.ravnborg.org>
References: <1316224159-3556-1-git-send-email-john.stultz@linaro.org>
	 <1316224159-3556-2-git-send-email-john.stultz@linaro.org>
	 <20110917060625.GA27128@merkur.ravnborg.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 19 Sep 2011 12:34:39 -0700
Message-ID: <1316460879.3112.16.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-09-17 at 08:06 +0200, Sam Ravnborg wrote:
> On Fri, Sep 16, 2011 at 06:49:18PM -0700, John Stultz wrote:
> > This adds an "olddefconfig" build target, which updates a .config file
> > filling any any absent symbols with the Kconfig default value (note:
> > not the architecture defconfig value).
> 
> This looks like a shorthand for: make KCONFIG_ALLCONFIG=.config alldefconfig
> Maybe we need the more obvious target - but the functionality is at least now new.

Thanks for pointing that out! 

Unless anyone feels differently, I'll go ahead and drop this patch and
will rework my merge_config.sh script to utilize the above.

thanks
-john


