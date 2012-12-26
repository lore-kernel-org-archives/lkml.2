Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752886Ab2LZBXx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Dec 2012 20:23:53 -0500
Received: from mail-vc0-f173.google.com ([209.85.220.173]:62511 "EHLO
	mail-vc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752677Ab2LZBXv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Dec 2012 20:23:51 -0500
Date: Tue, 25 Dec 2012 20:23:45 -0500
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 16/25] PM / Domains: don't use [delayed_]work_pending()
Message-ID: <20121226012345.GJ10220@mtj.dyndns.org>
References: <1356141435-17340-1-git-send-email-tj@kernel.org>
 <21556832.hKrqJSonFg@vostro.rjw.lan>
 <20121225170328.GH10220@mtj.dyndns.org>
 <43765611.nGGJ409TUC@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <43765611.nGGJ409TUC@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On Tue, Dec 25, 2012 at 09:33:07PM +0100, Rafael J. Wysocki wrote:
> OK, so I'd generally prefer changelogs like this:
> 
> "There's no need to test whether a (delayed) work item is pending
> before queueing, flushing or cancelling it, so remove work_pending()
> tests used in those cases."
> 
> If that's fine with you, I'll queue up [16/25] and [11/25] for v3.9
> with the above as the changelog.

Sure thing.  Please go ahead.

Thanks.

-- 
tejun
