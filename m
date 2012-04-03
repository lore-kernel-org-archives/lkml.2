Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754958Ab2DCUJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Apr 2012 16:09:51 -0400
Received: from mailout-de.gmx.net ([213.165.64.22]:41719 "HELO
	mailout-de.gmx.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1754839Ab2DCUJi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Apr 2012 16:09:38 -0400
X-Authenticated: #4630777
X-Provags-ID: V01U2FsdGVkX1+W9zsq3xSW47eYhjQOrZEDnCj/Q9AoUI9a0fep1Y
	Cj/j0yzxrwwsuR
Date: Tue, 3 Apr 2012 22:09:32 +0200
From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] sky2: fix missing register reset on error path in
 sky2_test_msi()
Message-ID: <20120403200932.GA2383@Neptun>
References: <20120330173616.GC2703@Neptun>
 <20120403115547.799fcc1f@s6510.linuxnetplumber.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120403115547.799fcc1f@s6510.linuxnetplumber.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 03, 2012 at 11:55:47AM -0700, Stephen Hemminger wrote:
> Ok, but this is a non-serious error case. If request_irq() fails here,
> the driver is going to fail to load and on the failure path of
> sky2_probe will reset the chip on the way out.
> 
Youre right, this is more a cosmetic change than a fix for a real bug. 
