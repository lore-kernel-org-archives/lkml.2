Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755372Ab1CYWCD (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Mar 2011 18:02:03 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56217 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755148Ab1CYWCB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Mar 2011 18:02:01 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Greg KH <gregkh@suse.de>
Subject: Re: [RFC PATCHv2 1/4] drivers/otp: add initial support for OTP memory
Date: Fri, 25 Mar 2011 23:01:56 +0100
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: Jamie Iles <jamie@jamieiles.com>, linux-kernel@vger.kernel.org,
        vapier@gentoo.org
References: <1300980071-24645-1-git-send-email-jamie@jamieiles.com> <201103252112.22520.arnd@arndb.de> <20110325211246.GA8741@suse.de>
In-Reply-To: <20110325211246.GA8741@suse.de>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201103252301.56718.arnd@arndb.de>
X-Provags-ID: V02:K0:A0fXXGjag/BZZs37VxP2aNAMYw6OladHCvlOGWZDdjr
 bPh4kM/rKHBnUaGascX5a26lAu1WO0sL8jR8kq50AvH4SW/2Rz
 5n5b+r54UZGJhCCuthKsIMJap06b2Wcap0DtnL9dR4iWdl1rwX
 lttXexf6EcvzuSvB4iGAwIytBC0gGlBk7VKuGtybT3UxzqmOZE
 6CqX+6A17vJIWX015OeRA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 25 March 2011 22:12:46 Greg KH wrote:
> > Why is this a bus? You don't have any device matching code or similar,
> > and the devices typically are on an existing bus_type (e.g. platform_bus).
> > I think it would make more sense to do this as a class.
> 
> No, for new things, we want to use busses instead of classes please.
> Especially as this does create devices, which are best put on a bus
> somewhere.

I don't understand. Isn't that rather inconsistent?

I realize the same thing came up with the IIO subsystem, where I also
didn't understand it.

In my mental model of Linux drivers, a bus is something that physically
connects devices and the bus code matches devices with drivers, while a
class groups logical devices that get created by the driver itself.

	Arnd
