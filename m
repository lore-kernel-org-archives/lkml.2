Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755885Ab1H3Rnu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Aug 2011 13:43:50 -0400
Received: from out3.smtp.messagingengine.com ([66.111.4.27]:43443 "EHLO
	out3.smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755845Ab1H3Rnr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Aug 2011 13:43:47 -0400
X-Sasl-enc: I5g5LBpsOwMvQgeOhFwAHK+BhDdYVS4ccWpDSV4chWOO 1314726227
Date: Tue, 30 Aug 2011 10:41:57 -0700
From: Greg KH <greg@kroah.com>
To: KY Srinivasan <kys@microsoft.com>
Cc: "gregkh@suse.de" <gregkh@suse.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devel@linuxdriverproject.org" <devel@linuxdriverproject.org>,
        "virtualization@lists.osdl.org" <virtualization@lists.osdl.org>,
        Haiyang Zhang <haiyangz@microsoft.com>
Subject: Re: [PATCH 44/46] Staging: hv: vmbus: Fix checkpatch warnings in
 connection.c
Message-ID: <20110830174157.GD22868@kroah.com>
References: <1314469874-7017-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-1-git-send-email-kys@microsoft.com>
 <1314469905-7058-44-git-send-email-kys@microsoft.com>
 <20110829180934.GB23618@kroah.com>
 <6E21E5352C11B742B20C142EB499E048081B5318@TK5EX14MBXC126.redmond.corp.microsoft.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6E21E5352C11B742B20C142EB499E048081B5318@TK5EX14MBXC126.redmond.corp.microsoft.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 30, 2011 at 05:11:57PM +0000, KY Srinivasan wrote:
> Thanks Greg. I will fix this. I got these patches out just before Hurricane Irene
> hit the east coast. While we were lucky that it was not as bad as was predicted,
> we lost power and we still don't have power. I have come to a public library in
> a nearby town to check my email.  So, my responses will be sporadic over the 
> next couple of days (until we get power). I will try to address the issues you
> have raised as quickly as possible.

Ouch, good luck with the power and other cleanup, hopefully you didn't
have any water damage.

I'm in no rush for further patches, that's being driven by your end :)

greg k-h
