Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751592Ab2ISULP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Sep 2012 16:11:15 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:34569 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751292Ab2ISULM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Sep 2012 16:11:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kevin Hilman <khilman@deeprootsystems.com>
Subject: Re: [PATCH] cpufreq: OMAP: Check IS_ERR() instead of NULL for omap_device_get_by_hwmod_name
Date: Wed, 19 Sep 2012 22:17:42 +0200
User-Agent: KMail/1.13.6 (Linux/3.6.0-rc6+; KDE/4.6.0; x86_64; ; )
Cc: Axel Lin <axel.lin@gmail.com>, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, cpufreq@vger.kernel.org,
        linux-pm@vger.kernel.org
References: <1347932747.6562.3.camel@phoenix> <201209182052.57414.rjw@sisk.pl> <877grqj6qw.fsf@deeprootsystems.com>
In-Reply-To: <877grqj6qw.fsf@deeprootsystems.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201209192217.42157.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, September 19, 2012, Kevin Hilman wrote:
> "Rafael J. Wysocki" <rjw@sisk.pl> writes:
> 
> > On Tuesday, September 18, 2012, Axel Lin wrote:
> >> omap_device_get_by_hwmod_name() returns ERR_PTR on error.
> >> 
> >> Signed-off-by: Axel Lin <axel.lin@gmail.com>
> >
> > Kevin, should I take this?
> 
> Yes, please.
> 
> Acked-by: Kevin Hilman <khilman@ti.com>

Done.

Thanks,
Rafael
