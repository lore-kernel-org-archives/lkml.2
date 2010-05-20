Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753610Ab0ETDnn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 May 2010 23:43:43 -0400
Received: from science.horizon.com ([71.41.210.146]:12421 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753410Ab0ETDnm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 May 2010 23:43:42 -0400
Date: 19 May 2010 23:43:40 -0400
Message-ID: <20100520034340.15087.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: eric.dumazet@gmail.com, linux@horizon.com
Subject: Re: 2.6.34 + ssh segfault
Cc: linux-kernel@vger.kernel.org
In-Reply-To: <1274299765.2658.2.camel@edumazet-laptop>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> This makes no sense to me, the EIP is in the midle of an instruction.
> (29 <cf>           sub    %ecx,%edi )
> 
> Bad compiler, cosmic ray, bad hardware... I dont know.
> 
> Try to rebuild completely the kernel with gcc-4.5, or gcc-4.4.3 ?

Actually, I started just recompiing with the same compiler and am
suffering internal compiler errors.  Which go away when I type "make"
a second time.  I think I need to check my hardware.

So although it's a geniuine bug in *my* kernel, it's not looking
like a problem with the source code.

Apologies for the false alarm.
