Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753569Ab0LHHJQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Dec 2010 02:09:16 -0500
Received: from edison.jonmasters.org ([173.255.233.168]:54745 "EHLO
	edison.jonmasters.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750892Ab0LHHJO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Dec 2010 02:09:14 -0500
From: Jon Masters <jonathan@jonmasters.org>
To: Brett Rudley <brudley@broadcom.com>
Cc: devel <devel@linuxdriverproject.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
In-Reply-To: <1291791831.2779.126.camel@constitution.bos.jonmasters.org>
References: <1289272437.3916.440.camel@constitution.bos.jonmasters.org>
	 <7A94256FD72B884D9E7C55586C3CBCEE13840C62AA@SJEXCHCCR01.corp.ad.broadcom.com>
	 <1289880279.3916.889.camel@constitution.bos.jonmasters.org>
	 <1291791831.2779.126.camel@constitution.bos.jonmasters.org>
Content-Type: text/plain; charset="UTF-8"
Organization: World Organi[sz]ation Of Broken Dreams
Date: Wed, 08 Dec 2010 02:10:16 -0500
Message-ID: <1291792216.2779.128.camel@constitution.bos.jonmasters.org>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 (2.30.3-1.fc13) 
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 74.92.29.237
X-SA-Exim-Mail-From: jonathan@jonmasters.org
Subject: RE: PROBLEM: brcm80211 unable to survive suspend/resume cycle
X-SA-Exim-Version: 4.2.1 (built Sun, 08 Nov 2009 07:31:22 +0000)
X-SA-Exim-Scanned: Yes (on edison.jonmasters.org)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-12-08 at 02:03 -0500, Jon Masters wrote:
> On Mon, 2010-11-15 at 23:04 -0500, Jon Masters wrote:
> > On Tue, 2010-11-09 at 10:02 -0800, Brett Rudley wrote:
> > > Hey Jon, thanks for the heads up.  I can repro and am looking into it.
> > 
> > Did you get chance to poke much yet?
> 
> This is still an issue in 2.6.37-rc5. Do you have any update on it?

In 2.6.37-rc2 I was unable to remove the module and reload it
successfully. In the latest RC I am at least able to reload it and have
it work again after doing so. Could you (for the moment) just add some
kind of big-hammer type reset in the unsuspend code path? :)

Jon.


