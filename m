Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753219Ab1GEEhN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Jul 2011 00:37:13 -0400
Received: from mail-iw0-f174.google.com ([209.85.214.174]:49040 "EHLO
	mail-iw0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753067Ab1GEEhK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Jul 2011 00:37:10 -0400
Date: Mon, 4 Jul 2011 19:55:42 -0700
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Simon Budig <simon.budig@kernelconcepts.de>
Cc: linux-input@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Patch to add guarding parentheses to some macros in linux/input.h
Message-ID: <20110705025542.GE2724@core.coreip.homeip.net>
References: <4DE6AD3B.4000600@kernelconcepts.de>
 <4DEE02A0.7030702@kernelconcepts.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4DEE02A0.7030702@kernelconcepts.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Simon,

On Tue, Jun 07, 2011 at 12:51:12PM +0200, Simon Budig wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> On 06/01/2011 11:20 PM, Simon Budig wrote:
> > The attached patch adds parentheses to ensure correct operator precedence.
> 
> Seems this patch did not draw any attention to it. Is this because it is
> somewhat pointless? Or is it too uncontroversial?  :-)
> 
> I'd appreciate any hints on how to proceed from here.
> 

I do not believe that 'len' will give any trouble since there are no
computations done with this macro argument, but you are absolutely
correct that 'ev' and 'abs' should be protected in EVIOCGBIT and
EVIOC(G|S)ABS. I extracted the relevant changes from your patch and
queued for 3.1.

Thanks.

-- 
Dmitry
