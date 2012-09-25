Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753406Ab2IYHCu (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Sep 2012 03:02:50 -0400
Received: from ares07.inai.de ([5.9.24.206]:38607 "EHLO seven.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751097Ab2IYHCs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Sep 2012 03:02:48 -0400
Date: Tue, 25 Sep 2012 09:02:47 +0200 (CEST)
From: Jan Engelhardt <jengelh@inai.de>
To: Dave Yost <Dave@Yost.com>
cc: linux-kernel@vger.kernel.org
Subject: Re: RFE: tty color features
In-Reply-To: <D1425869-534B-4AD9-BF2E-956A76E29894@Yost.com>
Message-ID: <alpine.LNX.2.01.1209250901040.25195@nerf07.vanv.qr>
References: <D1425869-534B-4AD9-BF2E-956A76E29894@Yost.com>
User-Agent: Alpine 2.01 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 2012-09-25 08:01, Dave Yost wrote:

>It would be nice to be able to specify fg/bg colors at the tty level, 
>so that echoed characters can be colorized.

The tty layer does not know what $TERM is used, so it cannot reliably 
produce any codes. But you can edit GNU screen because it has that 
knowledge and the fds.

