Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756579Ab0I3Obk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Sep 2010 10:31:40 -0400
Received: from mail.lixom.net ([70.86.134.90]:34158 "EHLO mail.lixom.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756324Ab0I3Obj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Sep 2010 10:31:39 -0400
Date: Thu, 30 Sep 2010 09:31:39 -0500
From: Olof Johansson <olof@lixom.net>
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Jean Delvare <khali@linux-fr.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>
Subject: Re: [PATCH] dmi: export dmi data through debugfs
Message-ID: <20100930143139.GA25792@lixom.net>
References: <20100928211246.GA20941@lixom.net> <20100929093403.7db92388@endymion.delvare> <20100929145330.GA9351@lixom.net> <20100929171118.1dbf3fbb@endymion.delvare> <20100929222804.7f506ba5@lxorguk.ukuu.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20100929222804.7f506ba5@lxorguk.ukuu.org.uk>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 29, 2010 at 10:28:04PM +0100, Alan Cox wrote:
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

Sure. I didn't think a trivial patch like this would get pushback,
but that's a workable fallback for my use case.


Thanks,

-Olof
