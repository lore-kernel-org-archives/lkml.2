Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752746Ab0I3SAF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 14:00:05 -0400
Received: from zone0.gcu-squad.org ([212.85.147.21]:36744 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751603Ab0I3SAD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 14:00:03 -0400
Date: Thu, 30 Sep 2010 19:59:42 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: Alan Cox <alan@lxorguk.ukuu.org.uk>, Olof Johansson <olof@lixom.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] dmi: export dmi data through debugfs
Message-ID: <20100930195942.6780c7a6@endymion.delvare>
In-Reply-To: <87pqvvuoce.fsf@basil.nowhere.org>
References: <20100928211246.GA20941@lixom.net>
	<20100929093403.7db92388@endymion.delvare>
	<20100929145330.GA9351@lixom.net>
	<20100929171118.1dbf3fbb@endymion.delvare>
	<20100929222804.7f506ba5@lxorguk.ukuu.org.uk>
	<87pqvvuoce.fsf@basil.nowhere.org>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.1; x86_64-unknown-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Andi,

On Thu, 30 Sep 2010 19:34:57 +0200, Andi Kleen wrote:
> Alan Cox <alan@lxorguk.ukuu.org.uk> writes:
> 
> >> Now if you really insist on exposing the whole DMI table through sysfs,
> >> I can't prevent you from doing that. After all, ACPI already exposes
> >> its tables under /sys/firmware/acpi/tables (mode 0400). But then you'd
> >> rather expose the DMI entry point and tables
> >> under /sys/firmware/dmi/tables for consistency, rather than using
> >> debugfs. But again, I don't think it is adding any value over what we
> >> already have.
> >
> > If you really the DMI data generally available run dmidecode in the boot
> > scripts directed to a file. It even has a dump mode for this.
> 
> FWIW i have been pondering to put DMI into sysfs too. One of the reasons
> mcelog has to start up as root is that it needs to get these tables
> out of /dev/mem.
> 
> Just having a binary file to read would be fine though, no need to 
> do decoding.

Out of curiosity, what exactly does mcelog need out of the DMI data?

-- 
Jean Delvare
