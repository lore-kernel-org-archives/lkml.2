Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755657Ab2JLG1J (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 02:27:09 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:42733 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753024Ab2JLG1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 02:27:07 -0400
Date: Fri, 12 Oct 2012 15:26:59 +0900
From: Mark Brown <broonie@opensource.wolfsonmicro.com>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Valdis.Kletnieks@vt.edu,
        Jakub Jelinek <jakub@redhat.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] regmap: silence GCC warning
Message-ID: <20121012062657.GO11726@opensource.wolfsonmicro.com>
References: <1349000155.1553.27.camel@x61.thuisdomein>
 <20121001100321.GB4360@opensource.wolfsonmicro.com>
 <64681.1349223065@turing-police.cc.vt.edu>
 <1349249016.1414.55.camel@x61.thuisdomein>
 <59004.1349475644@turing-police.cc.vt.edu>
 <20121006085306.GB8590@opensource.wolfsonmicro.com>
 <1349517456.1491.33.camel@x61.thuisdomein>
 <20121008011429.GA19748@opensource.wolfsonmicro.com>
 <1349726790.1397.13.camel@x61.thuisdomein>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1349726790.1397.13.camel@x61.thuisdomein>
X-Cookie: You are always busy.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 08, 2012 at 10:06:30PM +0200, Paul Bolle wrote:

> Long story short: Jakub Jelinek pointed out that there is a type
> mismatch between 'num' in regmap_volatile_range() and 'val_count' in
> regmap_raw_read(). And indeed, converting 'num' to the type of
> 'val_count' (ie, size_t) makes this warning go away.

Applied, thanks.
