Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755905Ab0JEA0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Oct 2010 20:26:49 -0400
Received: from mail.perches.com ([173.55.12.10]:2657 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754247Ab0JEA0r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Oct 2010 20:26:47 -0400
Subject: Re: [PATCH] serial8250: ratelimit "too much work" error
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Daniel Drake <dsd@laptop.org>, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Greg KH <greg@kroah.com>
In-Reply-To: <20101004164911.c8348e7e.akpm@linux-foundation.org>
References: <20101002110438.801F49D401B@zog.reactivated.net>
	 <20101004145101.b28fdc0a.akpm@linux-foundation.org>
	 <20101004150238.fbc1b6cf.akpm@linux-foundation.org>
	 <1286230259.10512.81.camel@Joe-Laptop>
	 <20101004152102.1e04f30a.akpm@linux-foundation.org>
	 <1286233169.10512.85.camel@Joe-Laptop>
	 <20101004161139.2a988b85.akpm@linux-foundation.org>
	 <1286235245.10512.91.camel@Joe-Laptop>
	 <20101004164911.c8348e7e.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Mon, 04 Oct 2010 17:26:46 -0700
Message-ID: <1286238406.10512.111.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2010-10-04 at 16:49 -0700, Andrew Morton wrote:
> Look at the file!  It all does one thing.  It encapsulates a single
> concept.  It's simply a bad thing to add single-concept
> application-specific material into that.  Layering, and all that.

Take a look at kernel.h recently?


