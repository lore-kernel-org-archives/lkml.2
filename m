Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1768772Ab2KOTSp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 14:18:45 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:33061 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1768721Ab2KOTSo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 14:18:44 -0500
Date: Thu, 15 Nov 2012 20:18:33 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Subject: Re: [PATCH 2/4] pinctrl: kirkwood: Prevent NULL dereference if
 of_match_device returns NULL
Message-ID: <20121115201833.07ec01c6@skate>
In-Reply-To: <1352955159.6793.2.camel@phoenix>
References: <1352955096.6793.1.camel@phoenix>
	<1352955159.6793.2.camel@phoenix>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Axel Lin,

On Thu, 15 Nov 2012 12:52:39 +0800, Axel Lin wrote:
> of_match_device() may return NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Why? We already discussed together that this situation could not
happen: if you are in the probe() function, then there *must* be a
match, because the probe() function precisely gets called when there is
a match.

So unless you give more details about what the problem is, I don't
think this patch and the similar one you sent for Dove are useful.

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
