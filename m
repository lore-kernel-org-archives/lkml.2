Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753322Ab2EBNBE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 May 2012 09:01:04 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:55953 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751565Ab2EBNBC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 May 2012 09:01:02 -0400
Date: Wed, 2 May 2012 14:03:21 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: Magnus Damm <magnus.damm@gmail.com>
Cc: linux-serial@vger.kernel.org, horms@verge.net.au, arnd@arndb.de,
        linux-sh@vger.kernel.org, gregkh@linuxfoundation.org,
        swarren@wwwdotorg.org, linux-kernel@vger.kernel.org, rjw@sisk.pl,
        paul.gortmaker@windriver.com, lethal@linux-sh.org, olof@lixom.net,
        dan.j.williams@intel.com, alan@linux.intel.com
Subject: Re: [PATCH 00/06] serial8250: DLL/DLM rework, Emma Mobile UART
 driver
Message-ID: <20120502140321.54f7af9c@pyramind.ukuu.org.uk>
In-Reply-To: <20120502124642.30480.41373.sendpatchset@w520>
References: <20120502124642.30480.41373.sendpatchset@w520>
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.8; x86_64-redhat-linux-gnu)
Face: iVBORw0KGgoAAAANSUhEUgAAADAAAAAwBAMAAAClLOS0AAAAFVBMVEWysKsSBQMIAwIZCwj///8wIhxoRDXH9QHCAAABeUlEQVQ4jaXTvW7DIBAAYCQTzz2hdq+rdg494ZmBeE5KYHZjm/d/hJ6NfzBJpp5kRb5PHJwvMPMk2L9As5Y9AmYRBL+HAyJKeOU5aHRhsAAvORQ+UEgAvgddj/lwAXndw2laEDqA4x6KEBhjYRCg9tBFCOuJFxg2OKegbWjbsRTk8PPhKPD7HcRxB7cqhgBRp9Dcqs+B8v4CQvFdqeot3Kov6hBUn0AJitrzY+sgUuiA8i0r7+B3AfqKcN6t8M6HtqQ+AOoELCikgQSbgabKaJW3kn5lBs47JSGDhhLKDUh1UMipwwinMYPTBuIBjEclSaGZUk9hDlTb5sUTYN2SFFQuPe4Gox1X0FZOufjgBiV1Vls7b+GvK3SU4wfmcGo9rPPQzgIabfj4TYQo15k3bTHX9RIw/kniir5YbtJF4jkFG+dsDK1IgE413zAthU/vR2HVMmFUPIHTvF6jWCpFaGw/A3qWgnbxpSm9MSmY5b3pM1gvNc/gQfwBsGwF0VCtxZgAAAAASUVORK5CYII=
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 02 May 2012 21:46:42 +0900
Magnus Damm <magnus.damm@gmail.com> wrote:

> serial8250: DLL/DLM rework, Emma Mobile UART driver
> 
> [PATCH 01/06] serial8250: Add dl_read()/dl_write() callbacks
> [PATCH 02/06] serial8250: Use dl_read()/dl_write() on Alchemy
> [PATCH 03/06] serial8250: Use dl_read()/dl_write() on RM9K
> [PATCH 04/06] serial8250: Clean up default map and dl code
> [PATCH 05/06] serial8250: Introduce serial8250_register_8250_port()
> [PATCH 06/06] serial8250-em: Add Emma Mobile UART driver
> 
> This series cleans up and adjusts the 8250 code base to allow
> hooking in a driver for the UART in Emma Mobile SoCs.
> 
> In short:
> - Patch 1-4 tie in 8250-specific dl_read()/dl_write() callbacks.
> - Patch 5 adds a new register function to use new callbacks.
> - Patch 6 adds a new driver that makes use of the above.
> 
> I'd be happy to rework the above patches if needed. The
> main challenge for Emma Mobile UART support is the non-
> standard offsets for DLL and DLM registers.
> 
> Note that there is no DT support included at this point,
> but it boils down to a 10 line change. The boot loader on
> my board does not do DT so I'd like to use kexec for DT
> development (as usual), but to use kexec I first need to
> get a non-DT kernel working. Which is basically this. =)
> 
> Signed-off-by: Magnus Damm <damm@opensource.se>

Acked-by: Alan Cox <alan@linux.intel.com>
