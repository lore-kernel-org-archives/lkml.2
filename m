Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754817Ab1DUQYQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Apr 2011 12:24:16 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:49612 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753462Ab1DUQYO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Apr 2011 12:24:14 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Guenter Roeck <guenter.roeck@ericsson.com>
Subject: Re: [PATCH v2] misc: Driver for Silicon Labs Si570 and compatibles
Date: Thu, 21 Apr 2011 18:23:21 +0200
User-Agent: KMail/1.13.5 (Linux/2.6.38+; KDE/4.5.1; x86_64; ; )
Cc: "Hans J. Koch" <hjk@hansjkoch.de>, "Greg Kroah-Hartman" <gregkh@suse.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Jonathan Cameron <kernel@jic23.retrosnub.co.uk>,
        Randy Dunlap <rdunlap@xenotime.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1303248968-5069-1-git-send-email-guenter.roeck@ericsson.com> <201104211311.25988.arnd@arndb.de> <20110421155658.GA28245@ericsson.com>
In-Reply-To: <20110421155658.GA28245@ericsson.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201104211823.21384.arnd@arndb.de>
X-Provags-ID: V02:K0:qhOhUDsth4d/vR/bDugEHeUNbzZlG688hD7O2vfCDKG
 2HHEQnTMxoBAQ3CX0vIzc5xT8po0PC7LIXUdNiqcNjfk5iNgHe
 dZUOww8pwqkLNctZp/0oi1+1QMMWG4vQ2L5bNRV3v5LI+wSL6n
 CUm7NB0FRPolAe11bSILwUfZhpuNCNC+BUfkwgWDBhTtjG7sci
 E3hkPdkjEY1DHdGaKo/bA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 21 April 2011 17:56:58 Guenter Roeck wrote:
> On Thu, Apr 21, 2011 at 07:11:25AM -0400, Arnd Bergmann wrote:
> > On Wednesday 20 April 2011, Guenter Roeck wrote:
> > 
> > Isn't that what you'd normally call a 'struct clk' then?
> > 
> Yes, it would be nice to have that as part of the kernel and not architecture
> specific.

I think the generalization of the ARM code is currently being worked
on, so this should be there soon.

	Arnd
