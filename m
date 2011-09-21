Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751748Ab1IUGoM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Sep 2011 02:44:12 -0400
Received: from mail-fx0-f46.google.com ([209.85.161.46]:48255 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788Ab1IUGoK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Sep 2011 02:44:10 -0400
Date: Wed, 21 Sep 2011 08:44:23 +0200
From: Richard Cochran <richardcochran@gmail.com>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, Sam Ravnborg <sam@ravnborg.org>,
        gthelen@google.com, tartler@cs.fau.de,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH] kconfig: Add merge_config.sh script
Message-ID: <20110921064423.GA4103@netboy.at.omicron.at>
References: <1316582561-23066-1-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316582561-23066-1-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 20, 2011 at 10:22:41PM -0700, John Stultz wrote:
> After noticing almost every distro has their own method of managing
> config fragments, I went looking at some best practices, and wanted
> to try to consolidate some of the different approaches so this fairly
> simple infrastructure can be shared (and new distros/build systems
> don't have to implement yet another config fragment merge script).

John,

I have been wanting to make or find a way to start with an allnoconfig
and enable a short list of config options (and the options that are
needed to allow them). I don't want the other defaults at all.

Can I use your script for this? If not, is there another way to go
about it?

Thanks,
Richard
