Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756708Ab1KUUix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Nov 2011 15:38:53 -0500
Received: from mail-iy0-f174.google.com ([209.85.210.174]:52436 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756301Ab1KUUiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Nov 2011 15:38:51 -0500
Date: Mon, 21 Nov 2011 12:38:46 -0800
From: Tejun Heo <tj@kernel.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, g.liakhovetski@gmx.de,
        dan.j.williams@intel.com, nicolas.ferre@atmel.com,
        vinod.koul@intel.com
Subject: Re: [GIT PULL pm/for-next] pm: freezer updates
Message-ID: <20111121203846.GC25776@google.com>
References: <20111103223113.GR4417@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20111103223113.GR4417@google.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

Just heads up.  I incorporated the patch to drop
set_freezable_with_signal() in the series and rebased in on top of the
current master.  The new HEAD is 465708e9c8 "freezer: fix
wait_event_freezable/__thaw_task races".

   git://git.kernel.org/pub/scm/linux/kernel/git/tj/misc.git pm-freezer

Once the dmatest patch gets acked, I'll send a proper pull request.

Thank you.

-- 
tejun
