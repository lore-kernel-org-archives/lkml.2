Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753163Ab1ARVtm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jan 2011 16:49:42 -0500
Received: from mailout-de.gmx.net ([213.165.64.23]:41242 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752714Ab1ARVtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jan 2011 16:49:41 -0500
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX19tAksI+ZxtRtI/19chBZJeFemNBi8+dU53XYhzN6
	1bVBb/4Jse90uC
From: Peter =?iso-8859-15?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Greg Kroah-Hartman" <gregkh@suse.de>
Subject: Re: [PATCH] staging/vt6655: fix sparse warning "obsolete struct initializer"
Date: Tue, 18 Jan 2011 22:49:37 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.37; KDE/4.4.5; x86_64; ; )
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Charles Clement <caratorn@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jpirko@redhat.com>
References: <1294698486-23814-1-git-send-email-peterhuewe@gmx.de>
In-Reply-To: <1294698486-23814-1-git-send-email-peterhuewe@gmx.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201101182249.37405.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag 10 Januar 2011, 23:28:06 schrieb Peter Huewe:
> This patch fixes the sparse warnings
> "obsolete struct initializer, use C99 syntax" in vt6655/device_main.c
> by converting the struct to C99 syntax
> 
> KernelVersion: linux-next-20110110
> 
> Signed-off-by: Peter Huewe <peterhuewe@gmx.de>
> ---
 Ping - any updates on this one?

Thanks,
Peter
