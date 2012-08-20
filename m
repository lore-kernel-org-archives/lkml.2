Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753155Ab2HTCnN (ORCPT <rfc822;w@1wt.eu>);
	Sun, 19 Aug 2012 22:43:13 -0400
Received: from eth5850.nsw.adsl.internode.on.net ([59.167.243.217]:34480 "EHLO
	xionine.xdna.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751148Ab2HTCnM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 19 Aug 2012 22:43:12 -0400
X-Greylist: delayed 520 seconds by postgrey-1.27 at vger.kernel.org; Sun, 19 Aug 2012 22:43:12 EDT
From: Cam Hutchison <camh@xdna.net>
To: thierry.reding@avionic-design.de, linux-kernel@vger.kernel.org
Orig-To: Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: awful kconfig help texts.
Newsgroups: gmane.linux.kernel
References: <20120731151600.GA19412@redhat.com> <20120731170741.GA4735@x1.osrc.amd.com> <20120816095439.GA30794@avionic-0098.mockup.avionic-design.de> <20120816111044.GA12029@x1.osrc.amd.com> <20120816120541.GA10154@avionic-0098.adnet.avionic-design.de> <20120817061102.GA6003@avionic-0098.adnet.avionic-design.de>
Message-Id: <20120820023429.DB1AE35BC8@xionine.xdna.net>
Date: Mon, 20 Aug 2012 12:34:29 +1000 (EST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>How about the patch below?

>[...]
>+	  Generic Pulse-Width Modulation (PWM) support.
>+
>+	  In Pulse-Width Modulation, a variation of the width of pulses
>+	  in a rectangular pulse signal is used as a means to alter the
>+	  average power of the signal. Applications include efficient
>+	  power delivery and voltage regulation. In computer systems,
>+	  PWMs are commonly used to control fans or the brightness of
>+	  display backlights.
>+
>+	  This framework provides a generic interface to PWM devices
>+	  within the Linux kernel. On the driver side it provides an API
>+	  to register and unregister a PWM chip, an abstraction of a PWM
>+	  controller, that supports one or more PWM devices. Client
>+	  drivers can request PWM devices and use the generic framework
>+	  to configure as well as enable and disable them.
>+
>+	  The new generic framework replaces the legacy PWM framework
>+	  which allows only a single driver implementing the required
>+	  API. Not all legacy implementations have been ported to the
>+	  new framework yet. The new framework provides an API that is
>+	  backward compatible with the legacy framework so that existing
>+	  client drivers continue to work as expected.

Instead of writing "[Tt]he new framework", write "[Tt]his framework". In 4
years, this will no longer be so new. And when the next framework comes
along, this will look like it is referencing the new one instead of itself.


