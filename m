Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752532Ab0JSOfL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Oct 2010 10:35:11 -0400
Received: from lo.gmane.org ([80.91.229.12]:58768 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855Ab0JSOfJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Oct 2010 10:35:09 -0400
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: Grant Edwards <grant.b.edwards@gmail.com>
Subject: Re: [PATCH] Documentation about RS485 serial communications
Date: Tue, 19 Oct 2010 14:29:48 +0000 (UTC)
Message-ID: <i9ka0s$4ua$1@dough.gmane.org>
References: <20100408111310.524f7354@lxorguk.ukuu.org.uk>
 <4BBDD71D.1010700@evidence.eu.com> <4BFD1FB6.8050405@atmel.com>
 <4BFE2F38.8050200@evidence.eu.com> <4BFE41FD.2080804@atmel.com>
 <20100527102917.GB31253@pengutronix.de> <4C626CBF.9020609@evidence.eu.com>
 <20100811083214.21d2919e.randy.dunlap@oracle.com>
 <4C669120.8080707@evidence.eu.com> <4C686411.3060500@oracle.com>
 <20100815221906.GA24153@n2100.arm.linux.org.uk>
 <4CBD8EE4.5040808@evidence.eu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@dough.gmane.org
X-Gmane-NNTP-Posting-Host: dsl.comtrol.com
User-Agent: slrn/pre0.9.9-102 (Linux)
Cc: linux-serial@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: linux-serial@vger.kernel.org, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2010-10-19, Claudio Scordino <claudio@evidence.eu.com> wrote:

> +2. HARDWARE-RELATED CONSIDERATIONS
> +
> +   Some CPUs (e.g., Atmel AT91) contain a transceiver capable of working both
> +   as RS232 and RS485.

Pardon my curiosity, but I've looked at a few AT91 parts, and I've
never seen on with an internal transceiver -- nor does Google seem
able to find any.

Frankly, I'd be pretty surprised, since it would be very difficult
(fab-wise), to build a mircoprocessor with I/O cells capable of
withstanding the voltage levels specified in RS232.

Can you specify to which parts you're referring?

-- 
Grant Edwards               grant.b.edwards        Yow! I have the power to
                                  at               HALT PRODUCTION on all
                              gmail.com            TEENAGE SEX COMEDIES!!

