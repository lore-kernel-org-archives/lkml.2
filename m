Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752321Ab0EGWTZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 May 2010 18:19:25 -0400
Received: from earthlight.etchedpixels.co.uk ([81.2.110.250]:34305 "EHLO
	www.etchedpixels.co.uk" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751504Ab0EGWTX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 May 2010 18:19:23 -0400
Date: Fri, 7 May 2010 23:24:48 +0100
From: Alan Cox <alan@lxorguk.ukuu.org.uk>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>,
       Jacob Pan <jacob.jun.pan@linux.intel.com>,
       Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@elte.hu>,
       Alek Du <alek.du@intel.com>, Feng Tang <feng.tang@intel.com>,
       LKML <linux-kernel@vger.kernel.org>,
       Jacob Pan <jacob.jun.pan@intel.com>,
       Linus Torvalds <torvalds@linux-foundation.org>,
       Arjan van de Ven <arjan.van.de.ven@intel.com>
Subject: Re: RFD: Should we remove the HLT check?  (was Re: [PATCH 1/8] x86:
 avoid check hlt if no timer interrupts)
Message-ID: <20100507232448.343b5ebc@lxorguk.ukuu.org.uk>
In-Reply-To: <4BE479EA.3080005@zytor.com>
References: <1273254108-3234-1-git-send-email-jacob.jun.pan@linux.intel.com>
	<1273254108-3234-2-git-send-email-jacob.jun.pan@linux.intel.com>
	<4BE478C1.2060602@zytor.com>
	<4BE4791B.1060304@linux.intel.com>
	<4BE479EA.3080005@zytor.com>
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.18.9; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'd be cool skipping it for family 5 or newer.  I'm just wondering if we
> should kill it completely -- IIRC it was only a handful of 386/486
> systems which had problems, usually due to marginal power supplies which
> couldn't handle the noise of a variable load (DOS not having any power
> management would run at a reliable 100% load) -- that's not exactly the
> type of systems which would have survived to modern day.

Also SMM and hardware bugs on some platforms - Cyrix MediaGX 5510 for
example where a hlt at the wrong moment during ATA transfers hung the box
until power cycle. But all old old stuff.

Alan
