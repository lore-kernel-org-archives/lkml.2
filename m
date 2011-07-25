Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943Ab1GYVDc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Jul 2011 17:03:32 -0400
Received: from mga09.intel.com ([134.134.136.24]:61054 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752463Ab1GYVDa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Jul 2011 17:03:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.67,264,1309762800"; 
   d="scan'208";a="29954522"
Subject: Re: [PATCH] iwlagn: check for !priv->txq in
 iwlagn_wait_tx_queue_empty
From: wwguy <wey-yi.w.guy@intel.com>
To: Keith Packard <keithp@keithp.com>
Cc: Intel Linux Wireless <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
In-Reply-To: <yunvcuqunzd.fsf@aiko.keithp.com>
References: <1311622702-4807-1-git-send-email-keithp@keithp.com>
	 <1311621715.5579.138.camel@wwguy-huron>  <yunvcuqunzd.fsf@aiko.keithp.com>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 25 Jul 2011 13:59:07 -0700
Message-ID: <1311627547.13973.2.camel@wwguy-ubuntu>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2011-07-25 at 13:03 -0700, Keith Packard wrote:
> On Mon, 25 Jul 2011 12:21:55 -0700, "Guy, Wey-Yi" <wey-yi.w.guy@intel.com> wrote:
> 
> > but why you need it?, "start device" call will fail if can not allocate
> > priv->txq
> 
> The device is down, so start_device was never called. At least, that's
> my assumption -- I've got the wireless device 'disabled' in
> NetworkManager.
> 
the iwlagn_wait_tx_queue_empty() function only can be call from either
"flush" operation or from debugfs. I agree it is a problem if call from
debugfs. did you actually see the problem when it is not from debugfs().

there is a recent patch in mac80211 to make sure do not call "flush" is
not needed.

Thanks
Wey


