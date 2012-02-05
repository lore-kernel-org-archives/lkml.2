Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754854Ab2BEK7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 Feb 2012 05:59:33 -0500
Received: from 1wt.eu ([62.212.114.60]:61757 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753289Ab2BEK7c (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 Feb 2012 05:59:32 -0500
Date: Sun, 5 Feb 2012 11:59:23 +0100
From: Willy Tarreau <w@1wt.eu>
To: Christoph Biedl <linux-kernel.bfrz@manchmal.in-ulm.de>
Cc: Greg KH <gregkh@linuxfoundation.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [0/1] 3.0.20-stable review
Message-ID: <20120205105923.GC8334@1wt.eu>
References: <20120203220745.GA3459@kroah.com> <1328434946@msgid.manchmal.in-ulm.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1328434946@msgid.manchmal.in-ulm.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 05, 2012 at 11:20:48AM +0100, Christoph Biedl wrote:
> Greg KH wrote...
> 
> > Please let me know if anyone has any problems with it as soon as possible.
> 
> After two tests without any visible change in neither power
> consumption nor system stability: How do I identify computers where
> that patch _might_ change things? Does for example
> 
>     ACPI _OSC control for PCIe not granted, disabling ASPM
> 
> indicate that box isn't worth any efforts?

FWIW I have a board (Commell LP170G) which exhibits the exact same message,
and where 3.0.19 and 3.0.20 show exactly the same power consumption. If you
look at the patch, you'll notice that it doesn't affect boards which report
this message, it should only make a difference with those which report
"ACPI FADT declares the system doesn't support PCIe ASPM, so disable it".

Regards,
Willy

