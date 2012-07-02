Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756113Ab2GBSz7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Jul 2012 14:55:59 -0400
Received: from g5t0007.atlanta.hp.com ([15.192.0.44]:15186 "EHLO
	g5t0007.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750740Ab2GBSz5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Jul 2012 14:55:57 -0400
Message-ID: <1341255355.2750.23.camel@lorien2>
Subject: Re: [PATCH v2 0/2] Part 1: handle addr_assign_type for random
 addresses
From: Shuah Khan <shuah.khan@hp.com>
Reply-To: shuah.khan@hp.com
To: jeffrey.t.kirsher@intel.com
Cc: Danny Kukawka <danny.kukawka@bisect.de>,
        "David S. Miller" <davem@davemloft.net>,
        Danny Kukawka <dkukawka@suse.de>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Mon, 02 Jul 2012 12:55:55 -0600
In-Reply-To: <1328818164.3639.15.camel@jtkirshe-mobl>
References: <1328816934-11508-1-git-send-email-danny.kukawka@bisect.de>
	 <1328818164.3639.15.camel@jtkirshe-mobl>
Organization: ISS-Linux
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-02-09 at 12:09 -0800, Jeff Kirsher wrote:

> 
> Thanks Danny, I will add both patches to my queue so that we can
> validate the changes for ixgbevf and igbvf.

Jeff,

Which upstream kernel did this patch end up in? Also did it make it into
any of the stable releases?

Thanks,
-- Shuah

