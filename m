Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752585Ab2KTIlm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Nov 2012 03:41:42 -0500
Received: from mail2.gnudd.com ([213.203.150.91]:41063 "EHLO mail.gnudd.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751779Ab2KTIll (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Nov 2012 03:41:41 -0500
Date: Tue, 20 Nov 2012 09:41:35 +0100
From: Davide Ciminaghi <ciminaghi@gnudd.com>
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
Cc: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: introduce tables for readable/writeable/volatile/precious checks
Message-ID: <20121120084135.GC10665@mail.gnudd.com>
References: <1353331913-24941-1-git-send-email-ciminaghi@gnudd.com> <20121120060509.GB10560@opensource.wolfsonmicro.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <20121120060509.GB10560@opensource.wolfsonmicro.com>
X-Face: #Q;A)@_4.#>0+_%y]7aBr:c"ndLp&#+2?]J;lkse\^)FP^Lr5@O0{)J;'nny4%74.fM'n)M
	>ISCj.KmsL/HTxz!:Ju'pnj'Gz&.
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 20, 2012 at 03:05:11PM +0900, Mark Brown wrote:
> On Mon, Nov 19, 2012 at 02:31:53PM +0100, Davide Ciminaghi wrote:
> > Many of the regmap enabled drivers implementing one or more of the
> > readable, writeable, volatile and precious methods use the same code
> > pattern:
> > 
> > 	return ((reg >= X && reg <= Y) || (reg >= W && reg <= Z) || ...)
> > 
> > Switch to a data driven approach, using tables to describe
> > readable/writeable/volatile and precious registers ranges instead.
> > The table based check can still be overridden by passing the usual function
> > pointers via struct regmap_config.
> 
> Sorry, the code looks good but I just realised we already have a feature
> called ranges - the paged window support also calls the regions it uses
> ranges.  Can I suggest access_table or similar instead?  Sorry about
> that - I should've realised.

ok no problem, I'll change the name and resend.

Thanks and regards
Davide

