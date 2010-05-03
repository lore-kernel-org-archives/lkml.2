Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757126Ab0ECVpA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 May 2010 17:45:00 -0400
Received: from exchange.solarflare.com ([216.237.3.220]:17821 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753123Ab0ECVo6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 May 2010 17:44:58 -0400
Subject: Re: [PATCH] net: show stopped status in sysfs
From: Ben Hutchings <bhutchings@solarflare.com>
To: "Michael S. Tsirkin" <mst@redhat.com>
Cc: "David S. Miller" <davem@davemloft.net>,
       Eric Dumazet <eric.dumazet@gmail.com>,
       "Eric W. Biederman" <ebiederm@xmission.com>,
       Johannes Berg <johannes@sipsolutions.net>,
       Tom Herbert <therbert@google.com>, netdev@vger.kernel.org,
       linux-kernel@vger.kernel.org
In-Reply-To: <20100503212423.GA15998@redhat.com>
References: <20100503212423.GA15998@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Organization: Solarflare Communications
Date: Mon, 03 May 2010 22:44:53 +0100
Message-ID: <1272923093.27948.63.camel@localhost>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 03 May 2010 21:45:19.0646 (UTC) FILETIME=[ECF913E0:01CAEB09]
X-TM-AS-Product-Ver: SMEX-8.0.0.1181-6.000.1038-17360.005
X-TM-AS-Result: No--17.629100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-05-04 at 00:24 +0300, Michael S. Tsirkin wrote:
> When debugging faulty hardware (in case of virt, faulty
> emulation) I found it helpful to be able to examine
> stopped status of the interface. The following patch makes
> this visible in sysfs.
[...]

This is a per-queue attribute and should not be associated directly with
the netdev.

Ben.

-- 
Ben Hutchings, Senior Software Engineer, Solarflare Communications
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

