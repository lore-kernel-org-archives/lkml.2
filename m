Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757137Ab1DZUAa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Apr 2011 16:00:30 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:55155 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754905Ab1DZUA3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:00:29 -0400
X-Authority-Analysis: v=1.1 cv=pN6kzQkhXdmdOr6Akjoh3kGBD/S3UyPMKQp53EJY+ro= c=1 sm=0 a=i38SgkEfDKkA:10 a=5SG0PmZfjMsA:10 a=Q9fys5e9bTEA:10 a=OPBmh+XkhLl+Enan7BmTLg==:17 a=ozg2Z9UadTmBSCHySkkA:9 a=PUjeQqilurYA:10 a=OPBmh+XkhLl+Enan7BmTLg==:117
X-Cloudmark-Score: 0
X-Originating-IP: 67.242.120.143
Subject: Re: [PATCH] linux/string.h: Introduce streq macro.
From: Steven Rostedt <rostedt@goodmis.org>
To: Thiago Farina <tfransosi@gmail.com>
Cc: Joe Perches <joe@perches.com>, Alexey Dobriyan <adobriyan@gmail.com>,
        linux-kernel@vger.kernel.org
In-Reply-To: <BANLkTimf44AgMAViHrSEz78ifHUYb8ji6g@mail.gmail.com>
References: <ae304c124297e5ca75721398f398f6d524b615d2.1303843697.git.tfransosi@gmail.com>
	 <20110426190531.GA4556@p183>
	 <1303845468.18763.32.camel@gandalf.stny.rr.com>
	 <20110426192029.GA4686@p183>
	 <BANLkTinxvyxSK9f+kkQugNkQEBf1O65bLQ@mail.gmail.com>
	 <1303846642.18763.37.camel@gandalf.stny.rr.com>
	 <1303847110.24299.50.camel@Joe-Laptop>
	 <BANLkTimf44AgMAViHrSEz78ifHUYb8ji6g@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-15"
Date: Tue, 26 Apr 2011 16:00:27 -0400
Message-ID: <1303848027.18763.40.camel@gandalf.stny.rr.com>
Mime-Version: 1.0
X-Mailer: Evolution 2.30.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2011-04-26 at 16:47 -0300, Thiago Farina wrote:

> > Do you plan to convert the existing 2800?
> 
> I'd work on this without any problem.

Oh, and make sure you do each change as a separate patch to guarantee
that you get to the top of the "most contributed to the Linux kernel" on
LWN's who's done what article ;)

-- Steve


