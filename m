Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756128Ab0IWTJR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Sep 2010 15:09:17 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:50378
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755813Ab0IWTJP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Sep 2010 15:09:15 -0400
Date: Thu, 23 Sep 2010 12:09:35 -0700 (PDT)
Message-Id: <20100923.120935.173861259.davem@davemloft.net>
To: mikpe@it.uu.se
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [2.6.36-rc regression] occasional complete system hangs on
 sparc64 SMP
From: David Miller <davem@davemloft.net>
In-Reply-To: <19611.34846.813757.309183@pilspetsen.it.uu.se>
References: <19611.34846.813757.309183@pilspetsen.it.uu.se>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Mikael Pettersson <mikpe@it.uu.se>
Date: Thu, 23 Sep 2010 19:02:22 +0200

> The 2.6.36-rc kernels do appear to be solid on a UP Ultra5, but that
> one no longer does any gcc builds or tests, only kernel builds.
> 
> Any ideas, or do I have to try to bisect this?

I've seen this too, it's some kind of deadlock obviously.

Unfortunately I haven't gotten any further than you have in the
analysis.
