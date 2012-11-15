Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S2992863Ab2KOHfW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 Nov 2012 02:35:22 -0500
Received: from mail.free-electrons.com ([88.190.12.23]:52021 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S2992718Ab2KOHfU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 Nov 2012 02:35:20 -0500
Date: Thu, 15 Nov 2012 08:35:11 +0100
From: Thomas Petazzoni <thomas.petazzoni@free-electrons.com>
To: Axel Lin <axel.lin@ingics.com>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH 1/4] pinctrl: dove: Prevent NULL dereference if
 of_match_device returns NULL
Message-ID: <20121115083511.08f5a16f@skate>
In-Reply-To: <1352955096.6793.1.camel@phoenix>
References: <1352955096.6793.1.camel@phoenix>
Organization: Free Electrons
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Dear Axel Lin,

On Thu, 15 Nov 2012 12:51:36 +0800, Axel Lin wrote:
> of_match_device() may return NULL.
> 
> Signed-off-by: Axel Lin <axel.lin@ingics.com>

Could you detail under what conditions of_match_device() may return
NULL in the specific case of this driver? This of_match_device() call
is using the same dove_pinctrl_of_match array that is used to ->probe()
this driver. So I don't see how you can get into ->probe() without
having a matching entry.

Am I missing something?

Best regards,

Thomas
-- 
Thomas Petazzoni, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
