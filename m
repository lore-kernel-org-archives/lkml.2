Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752679Ab0IVXBO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Sep 2010 19:01:14 -0400
Received: from ogre.sisk.pl ([217.79.144.158]:60741 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750730Ab0IVXBN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Sep 2010 19:01:13 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: "Linux-pm mailing list" <linux-pm@lists.linux-foundation.org>
Subject: Re: [PATCH 0/2] PM: Wakeup sources and async suspend error path bug fix
Date: Thu, 23 Sep 2010 01:00:09 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.36-rc5-rjw+; KDE/4.4.4; x86_64; ; )
Cc: Kevin Hilman <khilman@deeprootsystems.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@suse.de>
References: <201009201957.40995.rjw@sisk.pl>
In-Reply-To: <201009201957.40995.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201009230100.09867.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, September 20, 2010, Rafael J. Wysocki wrote:
> Hi,
> 
> The following two patches are ready to go into linux-next from my point of
> view, so please let me know if there are any objections:
> 
> [1/2] - PM / Wakeup: Introduce wakeup source objects and event statistics (v3)
> 
> [2/2] - PM: Fix potential issue with failing asynchronous suspend

Due to the apparent lack of objections I applied the patches from this series
to suspend-2.6/linux-next.

Thanks,
Rafael
