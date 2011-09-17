Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752533Ab1IQGG2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 02:06:28 -0400
Received: from smtp.snhosting.dk ([87.238.248.203]:14543 "EHLO
	smtp.domainteam.dk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751058Ab1IQGG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 02:06:27 -0400
Date: Sat, 17 Sep 2011 08:06:25 +0200
From: Sam Ravnborg <sam@ravnborg.org>
To: John Stultz <john.stultz@linaro.org>
Cc: lkml <linux-kernel@vger.kernel.org>, gthelen@google.com, tartler@cs.fau.de,
        Dmitry Fink <Dmitry.Fink@palm.com>,
        Darren Hart <dvhart@linux.intel.com>,
        Eric B Munson <ebmunson@us.ibm.com>,
        Bruce Ashfield <Bruce.Ashfield@windriver.com>,
        Michal Marek <mmarek@suse.cz>, linux-kbuild@vger.kernel.org
Subject: Re: [PATCH 1/2] kconfig: Add make olddefconfig
Message-ID: <20110917060625.GA27128@merkur.ravnborg.org>
References: <1316224159-3556-1-git-send-email-john.stultz@linaro.org> <1316224159-3556-2-git-send-email-john.stultz@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1316224159-3556-2-git-send-email-john.stultz@linaro.org>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 16, 2011 at 06:49:18PM -0700, John Stultz wrote:
> This adds an "olddefconfig" build target, which updates a .config file
> filling any any absent symbols with the Kconfig default value (note:
> not the architecture defconfig value).

This looks like a shorthand for: make KCONFIG_ALLCONFIG=.config alldefconfig
Maybe we need the more obvious target - but the functionality is at least now new.

	Sam
