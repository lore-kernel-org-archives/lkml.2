Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932285Ab1F1S3d (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Jun 2011 14:29:33 -0400
Received: from relais.videotron.ca ([24.201.245.36]:64154 "EHLO
	relais.videotron.ca" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760345Ab1F1SZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Jun 2011 14:25:25 -0400
MIME-version: 1.0
Content-transfer-encoding: 7BIT
Content-type: TEXT/PLAIN; charset=US-ASCII
Date: Tue, 28 Jun 2011 14:25:16 -0400 (EDT)
From: Nicolas Pitre <nico@fluxnic.net>
X-X-Sender: nico@xanadu.home
To: Todd Poynor <toddpoynor@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Russell King <linux@arm.linux.org.uk>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 0/3] Add generic idle notifiers
In-reply-to: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
Message-id: <alpine.LFD.2.00.1106281422560.2142@xanadu.home>
References: <1309229190-25006-1-git-send-email-toddpoynor@google.com>
User-Agent: Alpine 2.00 (LFD 1167 2008-08-23)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 27 Jun 2011, Todd Poynor wrote:

> Add notifiers for idle entry and exit, called with IDLE_START when a
> CPU goes idle and IDLE_END when it goes out of idle, based on the
> existing idle notifiers for the x86_64 arch.
> 
> Convert x86_64 to use these notifiers, and call the notifiers on ARM.
> 
> Convert the ARM LEDs events for idle start/end to these notifiers.

This is nice.

Acked-by: Nicolas Pitre <nicolas.pitre@linaro.org>

for all 3 patches.


Nicolas
