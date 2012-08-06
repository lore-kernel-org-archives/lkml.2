Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755829Ab2HFJ5a (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Aug 2012 05:57:30 -0400
Received: from casper.infradead.org ([85.118.1.10]:51623 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755796Ab2HFJ51 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Aug 2012 05:57:27 -0400
Message-ID: <1344247026.11031.27.camel@sortiz-mobl>
Subject: Re: [PATCH] drivers: net: irda: bfin_sir: fix compile error
From: Samuel Ortiz <samuel@sortiz.org>
Reply-To: Samuel Ortiz <samuel@sortiz.org>
To: Bob Liu <lliubbo@gmail.com>, davem@davemloft.net
Cc: axel.lin@gmail.com, rmk+kernel@arm.linux.org.uk,
        gregkh@linuxfoundation.org, kuninori.morimoto.gx@renesas.com,
        ralf@linux-mips.org, linux-kernel@vger.kernel.org,
        sonic.zhang@analog.com, uclinux-dist-devel@blackfin.uclinux.org
Date: Mon, 06 Aug 2012 11:57:06 +0200
In-Reply-To: <CAA_GA1d=mXhcOh7UL+8thMcz8ueQ4PR1Ytz8KNj40=+py+X7tA@mail.gmail.com>
References: <1343630652-7220-1-git-send-email-lliubbo@gmail.com>
	 <CAA_GA1d=mXhcOh7UL+8thMcz8ueQ4PR1Ytz8KNj40=+py+X7tA@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.2-1+b1 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Bob,

On Mon, 2012-08-06 at 17:29 +0800, Bob Liu wrote:
> Hi Samuel,
> 
> Would you please take a look at this patch?
> Since without this patch, regression test for blackfin will fail:
> http://kisskb.ellerman.id.au/kisskb/matrix/
> 
> Thank you!
The patch looks fine to me:
Acked-by: Samuel Ortiz <samuel@sortiz.org>

Dave, do you want me to carry it and eventually get a pull request from
me, or would you prefer to apply it directly ? This is a fix for 3.6.

Cheers,
Samuel.


