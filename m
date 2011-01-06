Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753541Ab1AFULS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jan 2011 15:11:18 -0500
Received: from ksp.mff.cuni.cz ([195.113.26.206]:47874 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751869Ab1AFULR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jan 2011 15:11:17 -0500
Date: Thu, 6 Jan 2011 21:11:00 +0100
From: Pavel Machek <pavel@ucw.cz>
To: stefani@seibold.net
Cc: linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH] UDPCP Communication Protocol
Message-ID: <20110106201100.GA3582@ucw.cz>
References: <1293787785-3834-1-git-send-email-stefani@seibold.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1293787785-3834-1-git-send-email-stefani@seibold.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> UDPCP is a communication protocol specified by the Open Base Station
> Architecture Initiative Special Interest Group (OBSAI SIG). The
> protocol is based on UDP and is designed to meet the needs of "Mobile
> Communcation Base Station" internal communications. It is widely used by
> the major networks infrastructure supplier.

Why does it need to be in kernel?

> +struct udpcp_statistics {
> +	unsigned int txMsgs;		/* Num of transmitted messages */
> +	unsigned int rxMsgs;		/* Num of received messages */
> +	unsigned int txNodes;		/* Num of receiver nodes */
> +	unsigned int rxNodes;		/* Num of transmitter nodes */
> +	unsigned int txTimeout;		/* Num of unsuccessful transmissions */
> +	unsigned int rxTimeout;		/* Num of partial message receptions */
> +	unsigned int txRetries;		/* Num of resends */
> +	unsigned int rxDiscardedFrags;	/* Num of discarded fragments */
> +	unsigned int crcErrors;		/* Num of crc errors detected */
> +};
 
AvoidCamelCase.
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
