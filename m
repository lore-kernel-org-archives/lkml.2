Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753271Ab1HVSgQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Aug 2011 14:36:16 -0400
Received: from smtp1-g21.free.fr ([212.27.42.1]:36456 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182Ab1HVSgP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Aug 2011 14:36:15 -0400
Date: Mon, 22 Aug 2011 20:36:24 +0200
From: Jean-Francois Moine <moinejf@free.fr>
To: Joe Perches <joe@perches.com>
Cc: linux-media@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 14/14] [media] gspca: Use current logging styles
Message-ID: <20110822203624.7a382ef5@tele>
In-Reply-To: <1314026428.18461.10.camel@Joe-Laptop>
References: <cover.1313966088.git.joe@perches.com>
	<9927bff9b5f212dcbe867a9f882e53ed80bd9a0f.1313966090.git.joe@perches.com>
	<20110822105003.0002ef3c@tele>
	<1314026428.18461.10.camel@Joe-Laptop>
X-Mailer: Claws Mail 3.7.9 (GTK+ 2.24.5; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Aug 2011 08:20:28 -0700
Joe Perches <joe@perches.com> wrote:

> The primary current advantage is style standardization
> both in code and dmesg output.
> 
> Future changes to printk.h will reduce object sizes
> by centralizing the prefix to a singleton and
> emitting it only in pr_<level>.

Hi Joe,

OK, I did not see that you started such changes a long time ago!

Thanks and good luck!

Acked-by: Jean-Francois Moine <moinejf@free.fr>

-- 
Ken ar c'hentañ	|	      ** Breizh ha Linux atav! **
Jef		|		http://moinejf.free.fr/
