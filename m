Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754115Ab2BRWkB (ORCPT <rfc822;w@1wt.eu>);
	Sat, 18 Feb 2012 17:40:01 -0500
Received: from amber.ccs.neu.edu ([129.10.116.51]:55227 "EHLO
	amber.ccs.neu.edu" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753900Ab2BRWj7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 18 Feb 2012 17:39:59 -0500
Date: Sat, 18 Feb 2012 17:39:57 -0500
From: Jim Faulkner <jfaulkne@ccs.neu.edu>
To: Michael Cree <mcree@orcon.net.nz>
Cc: linux-alpha@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org, gregkh@linuxfoundation.org, rth@twiddle.net,
        ink@jurassic.park.msu.ru, mattst88@gmail.com,
        torvalds@linux-foundation.org, jay.estabrook@gmail.com
Subject: Re: [PATCH] fix modpost when CONFIG_ALPHA_TSUNAMI=y
Message-ID: <20120218223957.GB28758@alumni-linux.ccs.neu.edu>
References: <20120109003504.GA19756@alumni-linux.ccs.neu.edu> <20120218212431.GA25058@alumni-linux.ccs.neu.edu> <4F40264E.6050602@orcon.net.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <4F40264E.6050602@orcon.net.nz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 19, 2012 at 11:29:34AM +1300, Michael Cree wrote:
> >  
> > +#include <linux/module.h>
> 
> Wouldn't <linux/exports.h> be better?  I seem to recall that this was a
> problem with EXPORT_SYMBOL not being defined and I see my own personal
> fix (which I had completely forgotten to send upstream) was to include
> <linux/exports.h>

core_marvel.c and core_titan.c both include <linux/module.h> in the
mainline kernel, which is why I thought it was the appropriate fix for
core_tsunami.c.

