Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756136Ab1CRFp3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Mar 2011 01:45:29 -0400
Received: from mail-iy0-f174.google.com ([209.85.210.174]:60059 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750919Ab1CRFpW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Mar 2011 01:45:22 -0400
Date: Thu, 17 Mar 2011 23:45:17 -0600
From: Grant Likely <grant.likely@secretlab.ca>
To: Andres Salomon <dilinger@queued.net>
Cc: devicetree-discuss@lists.ozlabs.org, Daniel Drake <dsd@laptop.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 0/4] switch DT creation to using of_attach_node (v2)
Message-ID: <20110318054517.GI18545@angua.secretlab.ca>
References: <1300408356-15253-1-git-send-email-dilinger@queued.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1300408356-15253-1-git-send-email-dilinger@queued.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 17, 2011 at 05:32:32PM -0700, Andres Salomon wrote:
> This is attempt #2 to make OF core use of_attach_node for both promtree
> and flattree building.  This reworks of_attach_node quite a bit to conform
> with our expectations of how the DT should look in memory.
> 
> It's different in many ways from the original patches, so it's worth
> reviewing each in their entirety.

Thanks Andres,

Ping me on this stuff after the merge window.  I don't have time to
look at it now, but I'll do so right all the stuff for .39 is taken
care of.

g.
