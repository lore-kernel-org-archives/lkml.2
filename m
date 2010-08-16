Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753570Ab0HPM3k (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Aug 2010 08:29:40 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:37984 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752671Ab0HPM3j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Aug 2010 08:29:39 -0400
Message-ID: <4C692F31.2020705@neli.hopto.org>
Date: Mon, 16 Aug 2010 14:29:37 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Thunderbird 2.0.0.5 (Windows/20070716)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org
Subject: Re: [PATCH 7/9] RapidIO: Add handling for PW message from a lost
 device
References: <1281712686-31308-1-git-send-email-alexandre.bounine@idt.com> <1281712686-31308-8-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1281712686-31308-8-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
> Add check if PW message source device is accessible and change PW message
> handler to recover if PW message source device is not available anymore (power
> down or link disconnect).

I am not quite sure what the point is of this patch. What do you need to 
recover from?

> To avoid possible loss of notification, the PW message handler scans the route
> back from the source device to identify end of the broken link.

Do you mean if port-writes are dropped? Then they did not reach you in 
the first place. If a link in between is broken, the associated switch 
will 'complain' and send port-writes, no?

Micha
