Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754707Ab1BGT0e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Feb 2011 14:26:34 -0500
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:60478
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753936Ab1BGT0c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Feb 2011 14:26:32 -0500
Date: Mon, 07 Feb 2011 11:27:08 -0800 (PST)
Message-Id: <20110207.112708.193718501.davem@davemloft.net>
To: dtor@vmware.com
Cc: schwab@linux-m68k.org, geert@linux-m68k.org, rusty@rustcorp.com.au,
        linux-kernel@vger.kernel.org, linux-m68k@vger.kernel.org,
        linux-arch@vger.kernel.org
Subject: Re: Early crash
From: David Miller <davem@davemloft.net>
In-Reply-To: <20110207165829.GA13101@dtor-ws.eng.vmware.com>
References: <20110207081933.GA11855@dtor-ws.eng.vmware.com>
	<20110207.005010.28814928.davem@davemloft.net>
	<20110207165829.GA13101@dtor-ws.eng.vmware.com>
X-Mailer: Mew version 6.3 on Emacs 23.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dmitry Torokhov <dtor@vmware.com>
Date: Mon, 7 Feb 2011 08:58:29 -0800

> But, theoretically speaking, nothing stops GCC to align pointers with
> "gaps" as well? Let's say having everything (or some) aligned on
> quadword boundary even though arch is 32 bit?

The alignment business only applies to aggregates (ie. structs and
unions).

This has been confirmed via several weeks of expermentation with
different GCC versions on different platforms as well.
