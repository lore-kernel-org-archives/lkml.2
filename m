Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756525Ab0FOAJF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jun 2010 20:09:05 -0400
Received: from einhorn.in-berlin.de ([192.109.42.8]:44826 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755910Ab0FOAJE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jun 2010 20:09:04 -0400
X-Envelope-From: stefanr@s5r6.in-berlin.de
Date: Tue, 15 Jun 2010 02:08:53 +0200 (CEST)
From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: (no subject)
To: "Justin P. Mattock" <justinmattock@gmail.com>
cc: linux-kernel@vger.kernel.org, linux1394-devel@lists.sourceforge.net
In-Reply-To: <tkrat.5070b3a06affdcfa@s5r6.in-berlin.de>
Message-ID: <tkrat.d4be393549292688@s5r6.in-berlin.de>
References: <1276547208-26569-1-git-send-email-justinmattock@gmail.com>
 <1276547208-26569-8-git-send-email-justinmattock@gmail.com>
 <tkrat.6f2ad8e8a9e281c2@s5r6.in-berlin.de> <4C16AECD.50506@gmail.com>
 <tkrat.5070b3a06affdcfa@s5r6.in-berlin.de>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; CHARSET=us-ascii
Content-Disposition: INLINE
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 15 Jun, Stefan Richter wrote:
> which caused gcc 4.6 to warn about
>     variable 'destination' set but not used.
...
>  drivers/firewire/core-transaction.c |   11 +++++------
>  1 file changed, 5 insertions(+), 6 deletions(-)
...

Subject was meant to be [PATCH] firewire: core: remove unused variable.
-- 
Stefan Richter
-=====-==-=- -==- -====
http://arcgraph.de/sr/

