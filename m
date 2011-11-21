Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756880Ab1KUVVJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 16:21:09 -0500
Received: from ogre.sisk.pl ([217.79.144.158]:50200 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab1KUVVI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 16:21:08 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Tejun Heo <tj@kernel.org>
Subject: Re: [GIT PULL pm/for-next] pm: freezer updates
Date: Mon, 21 Nov 2011 22:23:53 +0100
User-Agent: KMail/1.13.6 (Linux/3.1.0-rc10+; KDE/4.6.0; x86_64; ; )
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        g.liakhovetski@gmx.de, dan.j.williams@intel.com,
        nicolas.ferre@atmel.com, vinod.koul@intel.com
References: <20111103223113.GR4417@google.com> <20111121203846.GC25776@google.com>
In-Reply-To: <20111121203846.GC25776@google.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201111212223.54130.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, November 21, 2011, Tejun Heo wrote:
> Hello,
> 
> Just heads up.  I incorporated the patch to drop
> set_freezable_with_signal() in the series and rebased in on top of the
> current master.  The new HEAD is 465708e9c8 "freezer: fix
> wait_event_freezable/__thaw_task races".
> 
>    git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-freezer
> 
> Once the dmatest patch gets acked, I'll send a proper pull request.

OK, thanks a lot!

Rafael
