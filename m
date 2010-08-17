Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757685Ab0HQPjQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Aug 2010 11:39:16 -0400
Received: from mailrelay002.isp.belgacom.be ([195.238.6.175]:3402 "EHLO
	mailrelay002.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753860Ab0HQPjO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Aug 2010 11:39:14 -0400
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: AvsEAI1IakzCTtAn/2dsb2JhbACgPnHANIMACIIvBIln
Date: Tue, 17 Aug 2010 17:39:08 +0200
From: Philippe De Muyter <phdm@macqel.be>
To: uClinux development list <uclinux-dev@uclinux.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [uClinux-dev] [PATCH] m68knommu : Fix strace support for
	68328/68360
Message-ID: <20100817153908.GA16155@frolo.macqel>
References: <20100817151142.GA11940@frolo.macqel> <AANLkTim3FQ4eOJ2xJR5Kv4PWDbh=tDL0+-NzOaX+dhXo@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AANLkTim3FQ4eOJ2xJR5Kv4PWDbh=tDL0+-NzOaX+dhXo@mail.gmail.com>
User-Agent: Mutt/1.5.16 (2007-06-09)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 17, 2010 at 11:14:32AM -0400, Mike Frysinger wrote:
> 
> unless i'm missing something, you're only changing whitespace here.

That's true,

> and these account for more than half the patch.  please keep
> whitespace changes separate from real changes.

but that makes comparing the resulting files 68328/entry.S and 68360/entry.S
easier.

Philippe

-- 
Philippe De Muyter  phdm at macqel dot be  Tel +32 27029044
Macq Electronique SA  rue de l'Aeronef 2  B-1140 Bruxelles  Fax +32 27029077
