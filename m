Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753302Ab2FLNOg (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Jun 2012 09:14:36 -0400
Received: from usmamail.tilera.com ([12.216.194.151]:64895 "EHLO
	USMAMAIL.TILERA.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752286Ab2FLNOf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Jun 2012 09:14:35 -0400
Message-ID: <4FD740B7.8090203@tilera.com>
Date: Tue, 12 Jun 2012 09:14:31 -0400
From: Chris Metcalf <cmetcalf@tilera.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:13.0) Gecko/20120604 Thunderbird/13.0
MIME-Version: 1.0
To: David Miller <davem@davemloft.net>
CC: <eric.dumazet@gmail.com>, <bhutchings@solarflare.com>, <arnd@arndb.de>,
        <linux-kernel@vger.kernel.org>, <netdev@vger.kernel.org>
Subject: Re: [PATCH v10] tilegx network driver: initial support
References: <4FCFA312.4020505@tilera.com> <20120606.115440.1245419453265419850.davem@davemloft.net> <201206072045.q57Kj2r1009249@farm-0002.internal.tilera.com> <20120611.170336.1197560839526564340.davem@davemloft.net>
In-Reply-To: <20120611.170336.1197560839526564340.davem@davemloft.net>
X-Enigmail-Version: 1.4.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 6/11/2012 8:03 PM, David Miller wrote:
> From: Chris Metcalf <cmetcalf@tilera.com>
> Date: Thu, 7 Jun 2012 16:45:02 -0400
>
>> This change adds support for the tilegx network driver based on the
>> GXIO IORPC support in the tilegx software stack, using the on-chip
>> mPIPE packet processing engine.
>>
>> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> Applied.

Glad to hear it.  Thanks for bearing with the multiple revisions.  I (we)
appreciate all your feedback, and that of Ben, Eric, Arnd, and other folks
who contributed their time.

The driver does depend on tilegx iorpc framework code that is currently
only in linux-next, but it should all come together properly for 3.6.

-- 
Chris Metcalf, Tilera Corp.
http://www.tilera.com



