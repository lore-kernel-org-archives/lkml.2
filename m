Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754762Ab0FKGQQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jun 2010 02:16:16 -0400
Received: from one.firstfloor.org ([213.235.205.2]:43818 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753161Ab0FKGQP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jun 2010 02:16:15 -0400
Date: Fri, 11 Jun 2010 08:16:10 +0200
From: Andi Kleen <andi@firstfloor.org>
To: "Justin P. Mattock" <justinmattock@gmail.com>
Cc: linux-kernel@vger.kernel.org, Andi Kleen <andi@firstfloor.org>
Subject: Re: warning from gcc version 4.6.0 20100416
Message-ID: <20100611061610.GA6864@basil.fritz.box>
References: <4C11A598.8090504@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4C11A598.8090504@gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 10, 2010 at 07:55:20PM -0700, Justin P. Mattock wrote:
> o.k. andi,
>
> here is the rest of the warnings that
> I see when compiling the kernel
>
> I can try and create some patches for
> this(hopefully!!)

The key point is that you need to review
each warning if it's a real bug or just a false
positive.

This is not always trivial, I got at least one
wrong in the earlier series (shut up one real bug)

-Andi
