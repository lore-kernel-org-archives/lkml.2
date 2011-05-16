Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753065Ab1EPJSM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 May 2011 05:18:12 -0400
Received: from www.linutronix.de ([62.245.132.108]:38976 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752527Ab1EPJSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 May 2011 05:18:10 -0400
Date: Mon, 16 May 2011 11:18:07 +0200
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: Daniel Drake <dsd@laptop.org>
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, dilinger@queued.net,
        devicetree-discuss@lists.ozlabs.org
Subject: Re: [PATCH 10/11] x86, olpc: Add XO-1 RTC driver
Message-ID: <20110516091807.GB26487@linutronix.de>
References: <1304166750-31125-1-git-send-email-dsd@laptop.org>
 <1304166750-31125-11-git-send-email-dsd@laptop.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <1304166750-31125-11-git-send-email-dsd@laptop.org>
X-Key-Id: 97C4700B
X-Key-Fingerprint: 09E2 D1F3 9A3A FF13 C3D3  961C 0688 1C1E 97C4 700B
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Daniel Drake | 2011-04-30 13:32:29 [+0100]:

>Add a driver to configure the XO-1 RTC via CS5536 MSRs, to be used as a
>system wakeup source via olpc-xo1-pm.
>
>Device detection is based on finding the relevant device tree node.
>
>Signed-off-by: Daniel Drake <dsd@laptop.org>
>Cc: devicetree-discuss@lists.ozlabs.org

Looks good to me.

Sebastian
