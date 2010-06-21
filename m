Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758433Ab0FUUnM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jun 2010 16:43:12 -0400
Received: from mail.bluewatersys.com ([202.124.120.130]:23008 "EHLO
	hayes.bluewaternz.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758399Ab0FUUnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jun 2010 16:43:09 -0400
Message-ID: <4C1FCEDA.3000303@bluewatersys.com>
Date: Tue, 22 Jun 2010 08:43:06 +1200
From: Ryan Mallon <ryan@bluewatersys.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.1.9) Gecko/20100423 Thunderbird/3.0.4
MIME-Version: 1.0
To: Jeremy Kerr <jeremy.kerr@canonical.com>
CC: linux-kernel@vger.kernel.org, Ben Herrenchmidt <benh@kernel.crashing.org>,
       linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 2/2] clk: Generic support for fixed-rate clocks
References: <1277098513.947920.264679354891.2.gpush@pororo>
In-Reply-To: <1277098513.947920.264679354891.2.gpush@pororo>
X-Enigmail-Version: 1.0.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/21/2010 05:35 PM, Jeremy Kerr wrote:
> Since most platforms will need a fixed-rate clock, add one. This will
> also serve as a basic example of an implementation of struct clk.
> 
> Signed-off-by: Jeremy Kerr <jeremy.kerr@canonical.com>
> 
> ---
>  include/linux/clk.h |   13 +++++++++++++
>  kernel/clk.c        |   14 ++++++++++++++
>  2 files changed, 27 insertions(+)
> 
> diff --git a/include/linux/clk.h b/include/linux/clk.h
> index 5c1098b..1dce473 100644
> --- a/include/linux/clk.h
> +++ b/include/linux/clk.h
> @@ -79,6 +79,19 @@ struct clk_ops {
>   */
>  int __clk_get(struct clk *clk);
>  
> +/* Simple fixed-rate clock */
> +struct clk_fixed {
> +	struct clk	clk;
> +	unsigned long	rate;
> +};

Not sure if this has been discussed already, but shouldn't rate be const
for a fixed clock?

~Ryan

-- 
Bluewater Systems Ltd - ARM Technology Solution Centre

Ryan Mallon         		5 Amuri Park, 404 Barbadoes St
ryan@bluewatersys.com         	PO Box 13 889, Christchurch 8013
http://www.bluewatersys.com	New Zealand
Phone: +64 3 3779127		Freecall: Australia 1800 148 751
Fax:   +64 3 3779135			  USA 1800 261 2934
