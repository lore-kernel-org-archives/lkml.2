Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753400Ab1LaWUi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Dec 2011 17:20:38 -0500
Received: from exchange.solarflare.com ([216.237.3.220]:39337 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1753251Ab1LaWUg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Dec 2011 17:20:36 -0500
Message-ID: <1325370028.13595.143.camel@deadeye>
Subject: Re: [PATCH 1/2] 8139cp/8139too: do not read into reserved registers
From: Ben Hutchings <bhutchings@solarflare.com>
To: Jason Wang <jasowang@redhat.com>
CC: <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <linux-kernel@vger.kernel.org>, <akong@redhat.com>
Date: Sat, 31 Dec 2011 23:20:28 +0100
In-Reply-To: <20111231094433.5433.67602.stgit@dhcp-8-146.nay.redhat.com>
References: <20111231094433.5433.67602.stgit@dhcp-8-146.nay.redhat.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [88.96.1.126]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18616.006
X-TM-AS-Result: No--13.257900-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2011-12-31 at 17:44 +0800, Jason Wang wrote:
> delay_eeprom() use long read for Cfg9346 register(offset 0x50) which may read
> into the area of reserved register(offset 0x53). Use byte read instead.
[...]

If they've been working like this for so long (from the start of git
history), maybe they're best left alone.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

