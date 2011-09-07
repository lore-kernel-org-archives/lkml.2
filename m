Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753977Ab1IGQsQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Sep 2011 12:48:16 -0400
Received: from smtp.duncanthrax.net ([89.31.1.170]:39805 "EHLO
	smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753569Ab1IGQsF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Sep 2011 12:48:05 -0400
X-Greylist: delayed 1512 seconds by postgrey-1.27 at vger.kernel.org; Wed, 07 Sep 2011 12:48:05 EDT
From: Sven Schnelle <svens@stackframe.org>
To: Simon Kirby <sim@hostway.ca>
Cc: linux-kernel@vger.kernel.org, Jon Mason <mason@myri.com>,
        Jordan_Hargrave@dell.com
Subject: Re: [3.1-rc4] Bus Fatal Error caused by "PCI: Set PCI-E Max Payload Size on fabric"
Organization: private
In-Reply-To: <20110906173605.GA12577@hostway.ca> (Simon Kirby's message of "Tue\, 6 Sep 2011 10\:36\:05 -0700")
User-Agent: Gnus/5.11 (Gnus v5.11) Emacs/22.3 (gnu/linux)
References: <20110906173605.GA12577@hostway.ca>
Date: Wed, 07 Sep 2011 18:22:19 +0200
Message-ID: <87aaag9vb8.fsf@begreifnix.stackframe.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Simon Kirby <sim@hostway.ca> writes:

> Hello!
>
> Since trying 3.1-rc4 on a few Dell servers, all of them have booted up
> with the amber error LED lit. "ipmitool sel list" shows:
>
>    1 | 09/06/2011 | 17:21:56 | Event Logging Disabled #0x72 | Log area reset/cleared | Asserted
>    2 | 09/06/2011 | 17:25:38 | Critical Interrupt #0x18 | Bus Fatal Error | Asserted
>    3 | 09/06/2011 | 17:25:38 | Unknown #0x1a | 
>    4 | 09/06/2011 | 17:25:38 | Unknown #0x1a | 

I'm seeing exact the same issue on a Dell 1950 Server. If anyone wants
me to try additional debugging/patches, feel free to do
so. Unfortunately i don't have the time/knowledge to debug that by myself.

Sven    
