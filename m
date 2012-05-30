Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756961Ab2E3HST (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 May 2012 03:18:19 -0400
Received: from he.sipsolutions.net ([78.46.109.217]:48166 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756921Ab2E3HSR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 May 2012 03:18:17 -0400
Message-ID: <1338362288.4511.7.camel@jlt3.sipsolutions.net>
Subject: Re: [PATCH] iwlwifi: fix typo 'IWL_WATCHHDOG_DISABLED'
From: Johannes Berg <johannes@sipsolutions.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Wey-Yi Guy <wey-yi.w.guy@intel.com>,
        Intel Linux Wireless <ilw@linux.intel.com>,
        "John W. Linville" <linville@tuxdriver.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Wed, 30 May 2012 09:18:08 +0200
In-Reply-To: <1338361709.1780.3.camel@x61.thuisdomein> (sfid-20120530_091345_630175_CC635231)
References: <1338361709.1780.3.camel@x61.thuisdomein>
	 (sfid-20120530_091345_630175_CC635231)
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2012-05-30 at 09:08 +0200, Paul Bolle wrote:
> Commit 7c5ba4a830cbb730770129b0004e2a06e47dbac5 ("iwlwifi: move queue
> watchdog into transport") introduced the named constant
> 'IWL_WATCHHDOG_DISABLED'. Rename it to 'IWL_WATCHDOG_DISABLED'.

Thanks, I've picked this up. Since we're in the merge window John isn't
taking new patches right now so it'll be a while until it shows up.

johannes

