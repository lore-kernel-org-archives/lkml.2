Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932082Ab0EKBZO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 May 2010 21:25:14 -0400
Received: from casper.infradead.org ([85.118.1.10]:43060 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751844Ab0EKBZK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 May 2010 21:25:10 -0400
Date: Mon, 10 May 2010 18:27:46 -0700
From: Arjan van de Ven <arjan@infradead.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] cpuidle: Add a repeating pattern detector to the
 menu governor
Message-ID: <20100510182746.7e923812@infradead.org>
In-Reply-To: <20100510143850.fde16046.akpm@linux-foundation.org>
References: <20100509160242.2e351e6a@infradead.org>
	<20100509160444.260ca9c9@infradead.org>
	<20100510143850.fde16046.akpm@linux-foundation.org>
Organization: Intel
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.16.6; i586-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-SRS-Rewrite: SMTP reverse-path rewritten from <arjan@infradead.org> by casper.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 10 May 2010 14:38:50 -0700
Andrew Morton <akpm@linux-foundation.org> wrote:

> > +	if (avg && stddev < STDDEV_THRESH)
> > +		data->predicted_us = avg;
> > +}
> 
> You got lucky there, because INTERVALS is a power of two.  If someone
> changes INTERVALS to 7, this code will ask for __udivdi3 and won't
> link on i364.

yeah you'd think it almost isn't an accident ;-)


-- 
Arjan van de Ven 	Intel Open Source Technology Centre
For development, discussion and tips for power savings, 
visit http://www.lesswatts.org
