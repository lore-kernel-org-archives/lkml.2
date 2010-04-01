Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754808Ab0DAVaW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Apr 2010 17:30:22 -0400
Received: from mail-vw0-f46.google.com ([209.85.212.46]:38877 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752514Ab0DAVaT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Apr 2010 17:30:19 -0400
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=date:from:x-x-sender:to:cc:subject:in-reply-to:message-id
         :references:user-agent:mime-version:content-type;
        b=V76ZqqCa6ZorlF08LN6jqDb2RK0zPmJZuLle6MXyo/N6oixquuXGu/gGzCZW95DmYo
         npd0gqGq0KDqMmcjqOQIU8RhknyjVigEFwv88VFB3/1Z1/QS5zmb7uZMAkEByCWYUkLp
         uNuptQQ9DARP6CguuIqUSIDPHlkNVqi6AOX4Y=
Date: Thu, 1 Apr 2010 17:30:10 -0400 (EDT)
From: Parag Warudkar <parag.lkml@gmail.com>
X-X-Sender: paragw@parag-laptop
To: "Rafael J. Wysocki" <rjw@sisk.pl>
cc: Parag Warudkar <parag.lkml@gmail.com>, linux-kernel@vger.kernel.org
Subject: Re: S2RAM broken on HP 8530p
In-Reply-To: <201004012208.37540.rjw@sisk.pl>
Message-ID: <alpine.DEB.2.00.1004011725540.2043@parag-laptop>
References: <alpine.DEB.2.00.1003312050370.1876@parag-laptop> <201004010316.17898.rjw@sisk.pl> <alpine.DEB.2.00.1003312136220.1726@parag-laptop> <201004012208.37540.rjw@sisk.pl>
User-Agent: Alpine 2.00 (DEB 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 1 Apr 2010, Rafael J. Wysocki wrote:

> Please try:
> 
> # echo devices > /sys/power/pm_test
> # echo mem > /sys/power/state
> 
> and see if that breaks too (it should get back to the command line in about
> 5-10 seconds).

That breaks too - hangs similarly during suspend. I enabled RTC tracing 
and every time it prints out different hash matches after reboot - 
tty/tty21, pcie04  and latest is 

[    0.865296] pcieport 0000:00:1c.1: hash matches

Also when the suspend fails the immediate boot after that I get a USB 
error on startup - unable to enumerate usb device on port 1. This error is 
not present on normal boots.

Parag
