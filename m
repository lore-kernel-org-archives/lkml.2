Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758742Ab0ERS7g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 May 2010 14:59:36 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:58673 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756747Ab0ERS7f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 May 2010 14:59:35 -0400
Date: Tue, 18 May 2010 20:06:24 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: emil@la.mine.nu
Cc: linux-kernel@vger.kernel.org
Subject: Re: Linux telephony - IXJ
Message-ID: <20100518200624.4ad2a6cc@lxorguk.ukuu.org.uk>
In-Reply-To: <20100518161313.GA5338@emil.homelinux.net>
References: <20100518161313.GA5338@emil.homelinux.net>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> The current kernel support for these cards is broken. They are not
> produced anymore so probably nobody will care about this message. 
> It is surprinsing though that while there is no other alternative
> telephony driver in the kernel the only one present is broken.

Most people moved to using winmodems and userspace driver stuff with
applications like asterisk I think

> I have tried on the same hardware kernel 2.4 + ixj version 1.2.2 works
> while kernel 2.6 + version 3.1.0 doesn't.

Do you know roughly what the last in kernel one that worked was - that
should make it rather easier to pin down where/when it broke.

Alan
