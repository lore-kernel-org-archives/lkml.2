Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757564Ab0DWVJy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Apr 2010 17:09:54 -0400
Received: from tex.lwn.net ([70.33.254.29]:35506 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754609Ab0DWVJt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Apr 2010 17:09:49 -0400
Date: Fri, 23 Apr 2010 15:09:46 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Florian Tobias Schandinat <FlorianSchandinat@gmx.de>
Cc: linux-kernel@vger.kernel.org, Harald Welte <laforge@gnumonks.org>,
       Deepak Saxena <dsaxena@laptop.org>, linux-fbdev@vger.kernel.org,
       JosephChan@via.com.tw, ScottFang@viatech.com.cn
Subject: Re: [PATCH 09/11] viafb: Do not probe for LVDS/TMDS on OLPC XO-1.5
Message-ID: <20100423150946.3c3046b2@bike.lwn.net>
In-Reply-To: <4BD2098E.70601@gmx.de>
References: <1271614873-5952-1-git-send-email-corbet@lwn.net>
	<1271614873-5952-10-git-send-email-corbet@lwn.net>
	<4BD2098E.70601@gmx.de>
Organization: LWN.net
X-Mailer: Claws Mail 3.7.5 (GTK+ 2.20.0; x86_64-redhat-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 23 Apr 2010 22:56:46 +0200
Florian Tobias Schandinat <FlorianSchandinat@gmx.de> wrote:

> I fear your analysis that the #ifdef's are not needed is wrong. At least 
> with this patch applied I get:
> 
> drivers/video/via/hw.c: In function 'init_tmds_chip_info':
> drivers/video/via/hw.c:2043: error: implicit declaration of function 
> 'machine_is_olpc'

No, the problem is the "embarrassing compilation error" I mentioned in
my other mail; it needs "#include <asm/olpc.h>" at the top of the file.

Sorry,

jon
