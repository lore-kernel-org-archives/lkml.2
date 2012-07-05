Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752667Ab2GEUbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jul 2012 16:31:17 -0400
Received: from mailout-eu.gmx.com ([213.165.64.44]:59493 "HELO
	mailout-eu.gmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751213Ab2GEUbQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jul 2012 16:31:16 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Thu, 05 Jul 2012 16:31:15 EDT
X-Authenticated: #50610217
X-Provags-ID: V01U2FsdGVkX1+KRhZxlDyKam5Sp4RAGQ/0+a5QoJdmEtRdrM3ckg
	xDUEyjevHCyoy2
Date: Thu, 5 Jul 2012 22:24:29 +0200
From: Martin Nyhus <martin.nyhus@gmx.com>
To: Ben Skeggs <bskeggs@redhat.com>
Cc: David Airlie <airlied@linux.ie>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org
Subject: Re: [bisected] nouveau: "Failed to idle channel x" after resume
Message-ID: <20120705222429.43586868@europa>
In-Reply-To: <20120611231842.221bd738@europa>
References: <20120611231842.221bd738@europa>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 11 Jun 2012 23:18:42 +0200 Martin Nyhus wrote:
> after resuming from suspend nouveau starts writing Failed to idle
> channel x (where x is 2 or 3) to the log and X appears to stop and
> then restart only to stop again. Starting Firefox after resuming
> triggers the bugs every time, and bisecting leads to 03bd6efa
> ("drm/nv50/fifo: use hardware channel kickoff functionality").

Hi Ben,
I'm still seeing this bug with the latest from Linus
(v3.5-rc5-98-g9e85a6f) and linux-next (next-20120705).

lspci output:
01:00.0 VGA compatible controller: nVidia Corporation G86 [GeForce
8400M GS] (rev a1)

Sorry I haven't followed up on this earlier,
Martin
