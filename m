Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753849Ab0KIXLm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Nov 2010 18:11:42 -0500
Received: from dallas.jonmasters.org ([72.29.103.172]:40913 "EHLO
	dallas.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752627Ab0KIXLl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Nov 2010 18:11:41 -0500
Subject: RE: PROBLEM: brcm80211 unable to survive suspend/resume cycle
From: Jon Masters <jonathan@jonmasters.org>
To: Brett Rudley <brudley@broadcom.com>
Cc: devel <devel@linuxdriverproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <7A94256FD72B884D9E7C55586C3CBCEE13840C62AA@SJEXCHCCR01.corp.ad.broadcom.com>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
	 <7A94256FD72B884D9E7C55586C3CBCEE13840C62AA@SJEXCHCCR01.corp.ad.broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation of Broken Dreams
Date: Tue, 09 Nov 2010 18:11:27 -0500
Message-ID: <1289344287.3916.529.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Do-Not-Run: Yes
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
X-SA-Exim-Scanned: No (on dallas.jonmasters.org); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2010-11-09 at 10:02 -0800, Brett Rudley wrote:
> Hey Jon, thanks for the heads up.  I can repro and am looking into it.

Ok. Happy to test any experimental patches and get you a fast
turn-around on results. After working a lot of the weekend on the i915
regression I'm almost at the point where 2.6.37-rc1 works with all of
the devices I want to use in this netbook, except for WiFi suspend.

Jon.


