Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754594Ab1ACTmb (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jan 2011 14:42:31 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50687
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752229Ab1ACTma (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jan 2011 14:42:30 -0500
Date: Mon, 03 Jan 2011 11:43:01 -0800 (PST)
Message-Id: <20110103.114301.102556157.davem@davemloft.net>
To: alex.buell@munted.org.uk
Cc: linux-fbdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Using s3virge card in Sun Blade 2000
From: David Miller <davem@davemloft.net>
In-Reply-To: <1294083541.17576.11.camel@lithium>
References: <1294072336.17576.7.camel@lithium>
	<20110103.105827.112602895.davem@davemloft.net>
	<1294083541.17576.11.camel@lithium>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Buell <alex.buell@munted.org.uk>
Date: Mon, 03 Jan 2011 19:39:01 +0000

> Secondly, is Linux fully capable of handling different graphic cards
> simultaneously? For example, plug in a pair of monitors and have
> consoles on both with disparate graphic cards i.e. XVR-500 and S3ViRGE
> etc? 

Technically I don't think it can do it currently.  Maybe just for
kernel message logging, but not for actual login consoles.

One TTY device is marked as the "console" and that's where all
tty[0-9]+ devices get instantiated upon.
