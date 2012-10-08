Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752994Ab2JHBOd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 7 Oct 2012 21:14:33 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:38952 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752006Ab2JHBOb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 7 Oct 2012 21:14:31 -0400
Date: Mon, 8 Oct 2012 02:14:29 +0100
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Valdis.Kletnieks@vt.edu, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] regmap: silence GCC warning
Message-ID: <20121008011429.GA19748@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein> <20121001100321.GB4360@opensource.wolfsonmicro.com> <64681.1349223065@turing-police.cc.vt.edu> <1349249016.1414.55.camel@x61.thuisdomein> <59004.1349475644@turing-police.cc.vt.edu> <20121006085306.GB8590@opensource.wolfsonmicro.com> <1349517456.1491.33.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349517456.1491.33.camel@x61.thuisdomein>
X-Cookie: Your domestic life may be harmonious.
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 06, 2012 at 11:57:36AM +0200, Paul Bolle wrote:

> 2) I hope to send in a second path shortly, changing 'num' to size_t. My
> main doubt is whether its problematic that the loop index in
> regmap_volatile_range() uses unsigned int too. If 'num' would exceed
> UINT_MAX, that loop would never finish, wouldn't it? But is that
> actually possible? Are there machines with that many registers?

It's possible, of course - people can give whatever random numbers they
like to registers.  It's not particularly likely, though, so probably as
well not to worry about it until it's actually a problem.
