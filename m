Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753289Ab1IQKNh (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Sep 2011 06:13:37 -0400
Received: from edu-smtp-01.edutel.nl ([88.159.1.175]:56983 "EHLO
	edu-smtp-01.edutel.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750830Ab1IQKNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Sep 2011 06:13:36 -0400
X-Greylist: delayed 487 seconds by postgrey-1.27 at vger.kernel.org; Sat, 17 Sep 2011 06:13:35 EDT
Message-ID: <4E7470E6.2000404@neli.hopto.org>
Date: Sat, 17 Sep 2011 12:05:26 +0200
From: Micha Nelissen <micha@neli.hopto.org>
User-Agent: Mozilla-Thunderbird 2.0.0.22 (X11/20091109)
MIME-Version: 1.0
To: Alexandre Bounine <alexandre.bounine@idt.com>
CC: akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org, Liu Gang <Gang.Liu@freescale.com>
Subject: Re: [PATCH] RapidIO: documentation update
References: <1316092759-5460-1-git-send-email-alexandre.bounine@idt.com>
In-Reply-To: <1316092759-5460-1-git-send-email-alexandre.bounine@idt.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alexandre Bounine wrote:
>  After the host has completed enumeration of the entire network it releases
>  devices by clearing device ID locks (calls rio_clear_locks()). For each endpoint
> -in the system, it sets the Master Enable bit in the Port General Control CSR
> +in the system, it sets the Discovered bit in the Port General Control CSR
>  to indicate that enumeration is completed and agents are allowed to execute
>  passive discovery of the network.

The host needs to set both. Without Master Enable an agent is not
supposed to initiate transactions on the "bus", that's the meaning of
that bit.

Micha
