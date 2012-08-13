Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753284Ab2HMSm5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Aug 2012 14:42:57 -0400
Received: from ogre.sisk.pl ([193.178.161.156]:36275 "EHLO ogre.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752450Ab2HMSmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Aug 2012 14:42:52 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH] timekeeping: Fix build when generic clockevents are enabled
Date: Mon, 13 Aug 2012 20:48:49 +0200
User-Agent: KMail/1.13.6 (Linux/3.5.0+; KDE/4.6.0; x86_64; ; )
Cc: Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
References: <1344513580-9571-1-git-send-email-broonie@opensource.wolfsonmicro.com> <alpine.LFD.2.02.1208131706440.32033@ionos> <20120813150738.GG13446@opensource.wolfsonmicro.com>
In-Reply-To: <20120813150738.GG13446@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201208132048.49731.rjw@sisk.pl>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 13, 2012, Mark Brown wrote:
> On Mon, Aug 13, 2012 at 05:07:06PM +0200, Thomas Gleixner wrote:
> > On Thu, 9 Aug 2012, Mark Brown wrote:
> 
> > > Commit a2c204 (timekeeping: Add suspend and resume of clock event devices)
> 
> > Against which tree is that?
> 
> -next.  I think Raphael already folded it into the offending commit.

In fact I'd applied the equivalent fix before I got your report. :-)
