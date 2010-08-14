Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756858Ab0HNVkn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Aug 2010 17:40:43 -0400
Received: from cantor.suse.de ([195.135.220.2]:50037 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756649Ab0HNVkR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Aug 2010 17:40:17 -0400
Date: Sat, 14 Aug 2010 14:04:35 -0700
From: Greg KH <gregkh@suse.de>
To: Patrick Pannuto <ppannuto@codeaurora.org>
Cc: linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        magnus.damm@gmail.com, grant.likely@secretlab.ca,
        Kevin Hilman <khilman@deeprootsystems.com>,
        Paul Mundt <lethal@linux-sh.org>, Magnus Damm <damm@opensource.se>,
        "Rafael J. Wysocki" <rjw@sisk.pl>, Eric Miao <eric.y.miao@gmail.com>,
        Dmitry Torokhov <dtor@mail.ru>, netdev@vger.kernel.org
Subject: Re: [PATCH 2/2] platform: Facilitate the creation of
 pseudo-platform buses
Message-ID: <20100814210435.GD7745@suse.de>
References: <1281484174-32174-1-git-send-email-ppannuto@codeaurora.org>
 <1281484174-32174-3-git-send-email-ppannuto@codeaurora.org>
 <4C649C25.5090808@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C649C25.5090808@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 12, 2010 at 06:13:09PM -0700, Patrick Pannuto wrote:
> On 08/10/2010 04:49 PM, Patrick Pannuto wrote:
> 
> ^^^ small bug here, this line should be deleted; any other comments though?

Sorry, been busy with the -rc1 merge stuff, I'll have more time to look
at it next week.

Well, after you address Grant's issues first :)

thanks,

greg k-h
