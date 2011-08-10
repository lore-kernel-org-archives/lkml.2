Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751234Ab1HJEHV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Aug 2011 00:07:21 -0400
Received: from wondertoys-mx.wondertoys.net ([206.117.179.246]:47801 "EHLO
	labridge.com" rhost-flags-OK-FAIL-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750778Ab1HJEHU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Aug 2011 00:07:20 -0400
Subject: Re: [PATCH] gianfar: reduce stack usage in gianfar_ethtool.c
From: Joe Perches <joe@perches.com>
To: Wang Shaoyan <stufever@gmail.com>
Cc: linux-kernel@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
        Wang Shaoyan <wangshaoyan.pt@taobao.com>
In-Reply-To: <CANxBZFpm-at-FgNdP9nefwFfpzHmTMMsPSNWKJuT2R6TazhsYQ@mail.gmail.com>
References: <1312943399-14435-1-git-send-email-wangshaoyan.pt@taobao.com>
	 <1312943316.11924.54.camel@Joe-Laptop>
	 <CANxBZFpm-at-FgNdP9nefwFfpzHmTMMsPSNWKJuT2R6TazhsYQ@mail.gmail.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 09 Aug 2011 21:07:17 -0700
Message-ID: <1312949237.11924.58.camel@Joe-Laptop>
Mime-Version: 1.0
X-Mailer: Evolution 2.32.2 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2011-08-10 at 11:50 +0800, Wang Shaoyan wrote:
> Yes, I want to test, but I can't open CONFIG_GIANFAR, because I can't
> find FSL_SOC, am i miss something?

A cross compiler for powerpc?

You can get one from here:
ftp://ftp.kernel.org/pub/tools/crosstool/files/bin/i686/

Pick an appropriate gcc for you.

Then read the process docs in Documentation/development-process
or google linux cross compiling.


