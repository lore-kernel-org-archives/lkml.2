Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751032Ab2FKRx2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Jun 2012 13:53:28 -0400
Received: from webmail.solarflare.com ([12.187.104.25]:21946 "EHLO
	ocex02.SolarFlarecom.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751007Ab2FKRx0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Jun 2012 13:53:26 -0400
Message-ID: <1339437203.2665.8.camel@bwh-desktop.uk.solarflarecom.com>
Subject: Re: [PATCH] net: socket: fixed coding style issues.
From: Ben Hutchings <bhutchings@solarflare.com>
To: Matthew Shaw <shaw500@gmail.com>
CC: <davem@emloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Date: Mon, 11 Jun 2012 18:53:23 +0100
In-Reply-To: <1339420656-11512-1-git-send-email-shaw500@gmail.com>
References: <1339420656-11512-1-git-send-email-shaw500@gmail.com>
Organization: Solarflare Communications
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-1.fc16) 
Content-Transfer-Encoding: 7bit
MIME-Version: 1.0
X-Originating-IP: [10.17.20.137]
X-TM-AS-Product-Ver: SMEX-10.0.0.1412-6.800.1017-18962.005
X-TM-AS-Result: No--14.250100-0.000000-31
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2012-06-11 at 14:17 +0100, Matthew Shaw wrote:
> Fixed an instance where brances are used but not needed, and some lines
> in the comments and code that exceed the 80 character limit.
> 
> Signed-off-by: Matthew Shaw <shaw500@gmail.com>
> ---
>  net/socket.c |  137 ++++++++++++++++++++++++++++++++--------------------------
>  1 file changed, 75 insertions(+), 62 deletions(-)
> 
> diff --git a/net/socket.c b/net/socket.c
> index 6e0ccc0..2133040 100644
> --- a/net/socket.c
> +++ b/net/socket.c
> @@ -8,48 +8,48 @@
>   *		Fred N. van Kempen, <waltje@uWalt.NL.Mugnet.ORG>
>   *
>   * Fixes:
> - *		Anonymous	:	NOTSOCK/BADF cleanup. Error fix in
> - *					shutdown()
> - *		Alan Cox	:	verify_area() fixes
> - *		Alan Cox	:	Removed DDI
> - *		Jonathan Kamens	:	SOCK_DGRAM reconnect bug
[...]

I would question whether such lists of bug fixes are worth keeping at
all.  The names should probably be kept as credits, but the details are
ancient history now.

Ben.

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

