Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754593Ab0I3GhA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 02:37:00 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:34902 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753554Ab0I3Gg7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 02:36:59 -0400
Date: Thu, 30 Sep 2010 08:36:39 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Olof Johansson <olof@lixom.net>, Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] dmi: export dmi data through debugfs
Message-ID: <20100930083639.3b9effa0@endymion.delvare>
In-Reply-To: <20100929222804.7f506ba5@lxorguk.ukuu.org.uk>
References: <20100928211246.GA20941@lixom.net>
	<20100929093403.7db92388@endymion.delvare>
	<20100929145330.GA9351@lixom.net>
	<20100929171118.1dbf3fbb@endymion.delvare>
	<20100929222804.7f506ba5@lxorguk.ukuu.org.uk>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

On Wed, 29 Sep 2010 22:28:04 +0100, Alan Cox wrote:
> > Now if you really insist on exposing the whole DMI table through sysfs,
> > I can't prevent you from doing that. After all, ACPI already exposes
> > its tables under /sys/firmware/acpi/tables (mode 0400). But then you'd
> > rather expose the DMI entry point and tables
> > under /sys/firmware/dmi/tables for consistency, rather than using
> > debugfs. But again, I don't think it is adding any value over what we
> > already have.
> 
> If you really the DMI data generally available run dmidecode in the boot
> scripts directed to a file. It even has a dump mode for this.

Dump mode? Do you mean dmidecode --dump, dmidecode --dump-bin, or
something of your own?

-- 
Jean Delvare
