Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754066Ab1HOOaY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Aug 2011 10:30:24 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:39902 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753556Ab1HOOaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Aug 2011 10:30:18 -0400
X-Authenticated: #12255092
X-Provags-ID: V01U2FsdGVkX1+9pTw9t2298R57yZePMbd/p1/pNklgn0G0MdNvXB
	QaUYckaCQEj8zI
From: Peter =?iso-8859-2?q?H=FCwe?= <PeterHuewe@gmx.de>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH] shmobile/sh7372: Add missing CONFIG_PM guards to fix build failure
Date: Mon, 15 Aug 2011 16:30:11 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.39.3; KDE/4.4.5; x86_64; ; )
Cc: Paul Mundt <lethal@linux-sh.org>, Magnus Damm <magnus.damm@gmail.com>,
        Russell King <linux@arm.linux.org.uk>, linux-sh@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
References: <1313274841-8322-1-git-send-email-peterhuewe@gmx.de> <201108140155.05625.rjw@sisk.pl>
In-Reply-To: <201108140155.05625.rjw@sisk.pl>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-2"
Content-Transfer-Encoding: 7bit
Message-Id: <201108151630.12120.PeterHuewe@gmx.de>
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Sonntag 14 August 2011, 01:55:05 schrieb Rafael J. Wysocki:
> On Sunday, August 14, 2011, Peter Huewe wrote:
> > This patch fixes a build failure with the ap4evb_defconfig by adding the
> > missing #ifdef CONFIG_PM.
> 
> This is not the right fix.  Besides, you seem to be testing linux-next
> and the build problem is in the linux-pm tree.
> 
> Please check if the appended patch fixes the problem for you.
> 
> Rafael
Works for me - compiles ;)

Reviewed-by: Peter Huewe <peterhuewe@gmx.de>

