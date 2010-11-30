Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756085Ab0K3TPv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Nov 2010 14:15:51 -0500
Received: from mail-ey0-f174.google.com ([209.85.215.174]:54954 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755451Ab0K3TPt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Nov 2010 14:15:49 -0500
DomainKey-Signature: a=rsa-sha1; c=nofws;
        d=gmail.com; s=gamma;
        h=from:reply-to:to:cc:subject:x-mailer:references:in-reply-to
         :content-type:content-id:date:message-id:mime-version
         :content-transfer-encoding;
        b=EcrlC7CVZQWjlbThsNWCexZdkMoEn1qlHMfv+UP1WLwfS0MJFq+4Ry9Cgv809jNJJP
         PongZ+wOOz3WcUws45SADYRpqEbHOPZkqUKwPkudzEWarueEyFex641YPd35Dm1ZN6uc
         HokGBEZdw9WZXZUaZXc63IqgPRYFCI29J4XJ0=
From: "Alexander E. Patrakov" <patrakov@gmail.com>
Reply-To: "Alexander E. Patrakov" <patrakov@gmail.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: Nobody cared about IRQs at shutdown
X-Mailer: Modest 3.2
References: <4CF53D94.4090003@gmail.com>
	 <Pine.LNX.4.44L0.1011301355430.1686-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1011301355430.1686-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=utf-8
Content-ID: <1291144540.5573.3.camel@Nokia-N900-51-1>
Date: Wed, 01 Dec 2010 00:15:40 +0500
Message-Id: <1291144540.5573.4.camel@Nokia-N900-51-1>
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Alan Stern wrote:
> On Tue, 30 Nov 2010, Alexander E. Patrakov wrote:
> 
> > In fact, I think that there is something bad, not specific to USB, 
> > FireWire or SATA. Without systemd, all those subsystems function 
> > properly at shutdown. With systemd, it looks like there are many 
> > mishandled interrupts (all of USB, FireWire and SATA) at shutdown.
> > What    could be this common thing? ACPI?
> 
> I don't know -- what is systemd?

Systemd is a new init developed by Lennart Poettering. You can learn more at http://freedesktop.org/wiki/Software/systemd

It employs high concurrency in starting and stopping services, starts many things on demand and thus boots faster than the traditional SysV init. And also exposes this bug :(

-- 
Alexander E. Patrakov (from mobile phone)
