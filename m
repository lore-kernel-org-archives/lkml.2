Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755224Ab0KCNKf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Nov 2010 09:10:35 -0400
Received: from cantor2.suse.de ([195.135.220.15]:57901 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755169Ab0KCNKb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Nov 2010 09:10:31 -0400
Date: Wed, 3 Nov 2010 06:11:03 -0700
From: Greg KH <gregkh@suse.de>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Alan Stern <stern@rowland.harvard.edu>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Regression in 2.6.37-rc1 - logs spammed with "unable to
	enumerate USB port" - bisected to commit 3df7169e
Message-ID: <20101103131103.GC15885@suse.de>
References: <4CD09166.4060202@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4CD09166.4060202@lwfinger.net>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 02, 2010 at 05:32:06PM -0500, Larry Finger wrote:
> Commit 3df7169e73fc1d71a39cffeacc969f6840cdf52b causes my system to spam the
> logs with messages of the form "hub 2-0:1.0: unable to enumerate USB device on
> port 5". Bisection was used to locate the faulty commit.

<snip>

thanks for the bisection.  Alan and I are currently at the Plumbers
conference and will probably not be able to get to this until next week.

thanks,

greg k-h
