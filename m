Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757834Ab2ECR0A (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 May 2012 13:26:00 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:59808 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752063Ab2ECRZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 May 2012 13:25:59 -0400
Message-ID: <4FA2BFA5.20304@tilera.com>
Date: Thu, 3 May 2012 13:25:57 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:12.0) Gecko/20120428 Thunderbird/12.0.1
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <arnd@arndb.de>, <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v3] tilegx network driver: initial support
References: <201205011759.q41HxR21020043@farm-0012.internal.tilera.com> <20120503.014156.149171097979026872.davem@davemloft.net> <4FA2A81C.8020402@tilera.com> <20120503.130738.203857602354001769.davem@davemloft.net>
In-Reply-To: <20120503.130738.203857602354001769.davem@davemloft.net>
X-Enigmail-Version: 1.4.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/3/2012 1:07 PM, David Miller wrote:
> From: Chris Metcalf <cmetcalf@tilera.com>
> Date: Thu, 3 May 2012 11:45:32 -0400
>
>> Thanks, I've removed it from my branch.  (Since it's a trivial update, I
>> won't repost the change on LKML unless I get any more feedback that needs
>> addressing.)
> Sorry, this approach doesn't work, you should post a new version
> more expediently.
>
> When I see something so terrible like I saw this time, I just provide
> feedback on that major issue and stop reviewing.

Thanks, good to know.  Will do.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com

