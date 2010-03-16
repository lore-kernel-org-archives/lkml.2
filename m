Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S937646Ab0CPJ6W (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Mar 2010 05:58:22 -0400
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:54833
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S937622Ab0CPJ6V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Mar 2010 05:58:21 -0400
Date: Tue, 16 Mar 2010 02:58:43 -0700 (PDT)
Message-Id: <20100316.025843.38080670.davem@davemloft.net>
To: mingo@elte.hu
Cc: acme@infradead.org, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
       efault@gmx.de, a.p.zijlstra@chello.nl, paulus@samba.org
Subject: Re: [PATCH 2/2] perf top: Properly notify the user that vmlinux is
 missing
From: David Miller <davem@davemloft.net>
In-Reply-To: <20100316095523.GJ7961@elte.hu>
References: <20100316094611.GG7961@elte.hu>
	<20100316.025134.196872789.davem@davemloft.net>
	<20100316095523.GJ7961@elte.hu>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ingo Molnar <mingo@elte.hu>
Date: Tue, 16 Mar 2010 10:55:23 +0100

> So exposing a virtual ELF image via /sys (or /proc/kernel.so) wouldnt take up 
> much more RAM and would be rather useful, right?

Absolutely agreed.
