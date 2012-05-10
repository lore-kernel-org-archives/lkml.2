Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759950Ab2EJPSe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 May 2012 11:18:34 -0400
Received: from mail-ee0-f46.google.com ([74.125.83.46]:40460 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755449Ab2EJPSd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 May 2012 11:18:33 -0400
Subject: Re: [PATCH] net: device - added support of clearing device
 statistics
From: Eric Dumazet <eric.dumazet@gmail.com>
To: Sasikantha babu <sasikanth.v19@gmail.com>
Cc: "David S. Miller" <davem@davemloft.net>,
        =?UTF-8?Q?Micha=C5=82_Miros=C5=82aw?= <mirq-linux@rere.qmqm.pl>,
        Jiri Pirko <jpirko@redhat.com>,
        Ben Hutchings <bhutchings@solarflare.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
In-Reply-To: <1336662961-15033-1-git-send-email-sasikanth.v19@gmail.com>
References: <1336662961-15033-1-git-send-email-sasikanth.v19@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Thu, 10 May 2012 17:18:27 +0200
Message-ID: <1336663107.12504.155.camel@edumazet-glaptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2012-05-10 at 20:46 +0530, Sasikantha babu wrote:
> This patch adds the support of clearing device statistics. Added new 
> entry ndo_clear_stats to net_device_ops for device drivers to provide
> there own method to clear stats otherwise internal statistics structure
> is cleared.
> 
> Signed-off-by: Sasikantha babu <sasikanth.v19@gmail.com>

This is forbidden and racy.

SNMP counters must be increasing.



