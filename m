Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab1IUPue (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 11:50:34 -0400
Received: from e39.co.us.ibm.com ([32.97.110.160]:36132 "EHLO
	e39.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752275Ab1IUPuc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 11:50:32 -0400
Subject: Re: [PATCH] kconfig: Add merge_config.sh script
From: John Stultz <john.stultz@linaro.org>
To: Richard Cochran <richardcochran@gmail.com>
Cc: lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        gthelen@google.com, tartler@cs.fau.de,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
In-Reply-To: <20110921064423.GA4103@netboy.at.omicron.at>
References: <1316582561-23066-1-git-send-email-john.stultz@linaro.org>
	 <20110921064423.GA4103@netboy.at.omicron.at>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 21 Sep 2011 08:18:05 -0700
Message-ID: <1316618285.3112.204.camel@work-vm>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-09-21 at 08:44 +0200, Richard Cochran wrote:
> On Tue, Sep 20, 2011 at 10:22:41PM -0700, John Stultz wrote:
> > After noticing almost every distro has their own method of managing
> > config fragments, I went looking at some best practices, and wanted
> > to try to consolidate some of the different approaches so this fairly
> > simple infrastructure can be shared (and new distros/build systems
> > don't have to implement yet another config fragment merge script).
> 
> John,
> 
> I have been wanting to make or find a way to start with an allnoconfig
> and enable a short list of config options (and the options that are
> needed to allow them). I don't want the other defaults at all.

"make oldnoconfig" provides something close to this, I think. 

> Can I use your script for this? If not, is there another way to go
> about it?

I guess my script could take an option to use oldnoconfig instead of the
alldefconfig method.

thanks
-john



