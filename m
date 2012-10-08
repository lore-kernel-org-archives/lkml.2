Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753557Ab2JHOnY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Oct 2012 10:43:24 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:45831 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750963Ab2JHOnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Oct 2012 10:43:22 -0400
Date: Mon, 8 Oct 2012 15:42:43 +0100
From: Matthew Garrett <mjg@redhat.com>
To: Ondrej Zary <linux@rainbow-software.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Len Brown <len.brown@intel.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [bisected] PS/2 keyboard and mouse dead on resume on Intel
 D845BG
Message-ID: <20121008144243.GC5068@srcf.ucam.org>
References: <201210071513.27959.linux@rainbow-software.org>
 <201210072100.09813.linux@rainbow-software.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <201210072100.09813.linux@rainbow-software.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 07, 2012 at 09:00:09PM +0200, Ondrej Zary wrote:

> Added acpi_read_bit_register there and it seems that SCI_EN is already set!
> 
> This patch fixes the problem here. I wonder how this affects systems that
> require SCI_EN to be set.

I /think/ that this will be safe, but it doesn't match my recollection 
of how Windows behaves so it may break something. Any chance you can 
find someone with one of the machines mentioned in 
https://bugzilla.kernel.org/show_bug.cgi?id=13745 and make sure that 
they still work with your patch?

-- 
Matthew Garrett | mjg59@srcf.ucam.org
