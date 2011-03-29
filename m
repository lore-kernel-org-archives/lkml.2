Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752222Ab1C2OcH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Mar 2011 10:32:07 -0400
Received: from mga03.intel.com ([143.182.124.21]:7344 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751301Ab1C2OcG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Mar 2011 10:32:06 -0400
Message-Id: <849307$c7c8q8@azsmga001.ch.intel.com>
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.63,262,1299484800"; 
   d="scan'208";a="410395464"
Date: Tue, 29 Mar 2011 15:32:03 +0100
To: Pekka Enberg <penberg@kernel.org>
Subject: Re: [PATCH] drm/i915: Move the irq wait queue initialisation into the ring init
Cc: intel-gfx@lists.freedesktop.org, linux-kernel@vger.kernel.org
References: <1301395589-8121-1-git-send-email-chris@chris-wilson.co.uk> <1301401385-8935-1-git-send-email-chris@chris-wilson.co.uk> <AANLkTin0bicOYyY2WCaBxN276t5RV-Q9UZVr=WQ6NmQe@mail.gmail.com> <1bdc18$k1kc9s@fmsmga002.fm.intel.com> <AANLkTi=Adq8i_qoiHhLB9K-CkUbT8uHZeg-H8Z3_Kgrw@mail.gmail.com> <AANLkTi=ejDZYxyHYWXZiLXG+L1o8BqvQp8CQVhsUf570@mail.gmail.com>
From: Chris Wilson <chris@chris-wilson.co.uk>
In-Reply-To: <AANLkTi=ejDZYxyHYWXZiLXG+L1o8BqvQp8CQVhsUf570@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 29 Mar 2011 17:22:13 +0300, Pekka Enberg <penberg@kernel.org> wrote:
> No ssh - the box seems to be dead.

But now you have a machine with which to listen out for the netconsole
scream of anguish...
-Chris

-- 
Chris Wilson, Intel Open Source Technology Centre
