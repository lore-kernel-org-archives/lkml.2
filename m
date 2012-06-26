Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab2FZIJq (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Jun 2012 04:09:46 -0400
Received: from cpsmtpb-ews03.kpnxchange.com ([213.75.39.6]:2447 "EHLO
	cpsmtpb-ews03.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757100Ab2FZIJn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Jun 2012 04:09:43 -0400
Message-ID: <1340698181.2197.14.camel@x61.thuisdomein>
Subject: Re: [PATCH] avr32: Remove unused asm/numnodes.h
From: Paul Bolle <pebolle@tiscali.nl>
To: Hans-Christian Egtvedt <egtvedt@samfundet.no>
Cc: Haavard Skinnemoen <hskinnemoen@gmail.com>, linux-kernel@vger.kernel.org
Date: Tue, 26 Jun 2012 10:09:41 +0200
In-Reply-To: <20120626073255.GB7866@samfundet.no>
References: <1339174815.30984.8.camel@x61.thuisdomein>
	 <20120626073255.GB7866@samfundet.no>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 (3.2.3-3.fc16) 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-OriginalArrivalTime: 26 Jun 2012 08:09:42.0031 (UTC) FILETIME=[0A2761F0:01CD5373]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hans-Christian,

On Tue, 2012-06-26 at 09:32 +0200, Hans-Christian Egtvedt wrote:
> Around Fri 08 Jun 2012 19:00:15 +0200 or thereabout, Paul Bolle wrote:
> > This is handled with config options now.
> 
> Yes, but AVR32 doesn't have those bits in arch/avr32/Kconfig,

Correct. Currently only 11 of 26 architectures set the Kconfig symbol
NODES_SHIFT. avr32 is not one of those 11. 

>  hence removing
> the NODES_SHIFT definition will reduce it to 0 in include/Linux/numa.h. I
> suspect it is already done...

Sure, NODES_SHIFT will be defined as 0 in numa.h for avr32, because
CONFIG_NODES_SHIFT will never be defined for avr32.

Or do you mean that some file is actually using avr32's asm/numnodes.h?
How does that work?


Paul Bolle

