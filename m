Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755451Ab1LMSGu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Dec 2011 13:06:50 -0500
Received: from he.sipsolutions.net ([78.46.109.217]:35225 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754460Ab1LMSGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Dec 2011 13:06:48 -0500
Subject: Re: [Ilw] Re: REGRESSION: v3.2-rcX: iwlagn refuses to associate
 with my AP's
From: Johannes Berg <johannes@sipsolutions.net>
To: wwguy <wey-yi.w.guy@intel.com>
Cc: "Ted Ts'o" <tytso@mit.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ilw@linux.intel.com" <ilw@linux.intel.com>,
        "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1323798874.7144.4.camel@wwguy-ubuntu> (sfid-20111213_190527_823665_5563A461)
References: <E1RaBm1-0001JR-8a@tytso-glaptop.cam.corp.google.com>
	 <20111213172642.GA4962@thunk.org>  <1323798874.7144.4.camel@wwguy-ubuntu>
	 (sfid-20111213_190527_823665_5563A461)
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 13 Dec 2011 19:06:28 +0100
Message-ID: <1323799588.3355.28.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-12-13 at 09:54 -0800, wwguy wrote:

> Thank you for doing all those works, 
> 
> The "debcf73 iwlagn: handle GO powersave" is part of new WiFi Direct
> feature we are introducing for our up-coming new products. As you can
> see, the feature still under development and for sure there are a lot
> issues we need to flush out and make it perfect.
> 
> Here I attach a patch which will disable P2P feature by default, could
> you please give it a try, so we know for sure it is something being
> introduced by P2P changes. 

I don't think this will make a difference since tx_sync is still done.

johannes

