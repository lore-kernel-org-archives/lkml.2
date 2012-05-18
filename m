Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755306Ab2EREXS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 May 2012 00:23:18 -0400
Received: from cavan.codon.org.uk ([93.93.128.6]:40682 "EHLO
	cavan.codon.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753636Ab2EREXR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 May 2012 00:23:17 -0400
Date: Fri, 18 May 2012 05:23:01 +0100
From: Matthew Garrett <mjg59@srcf.ucam.org>
To: Stephen Hemminger <shemminger@vyatta.com>
Cc: David Miller <davem@davemloft.net>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Arnd Bergmann <arnd@arndb.de>,
        John Calixto <john.calixto@modsystems.com>,
        Pavel Emelyanov <xemul@parallels.com>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [RFC] econet: remove ancient bug ridden protocol
Message-ID: <20120518042301.GA723@srcf.ucam.org>
References: <20120517205951.462d336f@nehalam.linuxnetplumber.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20120517205951.462d336f@nehalam.linuxnetplumber.net>
User-Agent: Mutt/1.5.20 (2009-06-14)
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: mjg59@cavan.codon.org.uk
X-SA-Exim-Scanned: No (on cavan.codon.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, May 17, 2012 at 08:59:51PM -0700, Stephen Hemminger wrote:

> The ancient Econet protocol should go. Most of the bug fixes in recent
> years have been fixing security vulnerabilities. The hardware hasn't
> been made since 1981, it is only interesting as an archeological curiosity.

Pedantry - the hardware was introduced in 1981, it was still being made 
into at least the 90s. Still probably time for it to die, though.

-- 
Matthew Garrett | mjg59@srcf.ucam.org
