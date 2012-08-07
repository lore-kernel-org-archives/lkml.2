Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755021Ab2HGODO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Aug 2012 10:03:14 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:40277 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754036Ab2HGODN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Aug 2012 10:03:13 -0400
Date: Tue, 7 Aug 2012 15:03:11 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: "Opensource [Anthony Olech]" <anthony.olech.opensource@diasemi.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        David Dajun Chen <david.chen@diasemi.com>
Subject: Re: [PATCH] regmap-irq: allow auto-allocated IRQs to be mapped
Message-ID: <20120807140311.GH16861@opensource.wolfsonmicro.com>
References: <201208020805.q72858Yj003147@latitude.olech.com>
 <20120804105424.GB10523@opensource.wolfsonmicro.com>
 <24DF37198A1E704D9811D8F72B87EB51032C3B7E@NB-EX-MBX02.diasemi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <24DF37198A1E704D9811D8F72B87EB51032C3B7E@NB-EX-MBX02.diasemi.com>
X-Cookie: You will be married within a year.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 07, 2012 at 11:18:20AM +0000, Opensource [Anthony Olech] wrote:

> if you don't TOP POST how can you tell who wrote what?

Well, it's not clear who wrote what in your current e-mail since there's
no indication of what's quoted and what's new text...  Take a look at
all the other mails on the list - your mail should be in a similar style
to them.  There's some advice for common e-mail clients in email-clients.txt
under Documentation.

The bottom line here is that if your driver requires a dynamically
allocated legacy domain it is broken.
