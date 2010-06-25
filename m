Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755508Ab0FYM5n (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jun 2010 08:57:43 -0400
Received: from ozlabs.org ([203.10.76.45]:40963 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754086Ab0FYM5l (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jun 2010 08:57:41 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Andrew Morton <akpm@linux-foundation.org>
Subject: Re: linux-next: Tree for June 11
Date: Fri, 25 Jun 2010 22:27:35 +0930
User-Agent: KMail/1.13.2 (Linux/2.6.32-22-generic; KDE/4.4.2; i686; ; )
Cc: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
       LKML <linux-kernel@vger.kernel.org>
References: <20100611141738.cf8a6bbf.sfr@canb.auug.org.au> <201006151856.38882.rusty@rustcorp.com.au> <20100623155303.65ead123.akpm@linux-foundation.org>
In-Reply-To: <20100623155303.65ead123.akpm@linux-foundation.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201006252227.35693.rusty@rustcorp.com.au>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 24 Jun 2010 08:23:03 am Andrew Morton wrote:
> I bisected it down to 4624469822455b4accc886557f6c997ccdd59066
> ("module: kallsyms functions take struct load_info").  I couldn't see
> anything obviously wrong with it, but there's something screwy in
> there..

Great, thanks for bisecting.  I'll wrangle with it a little and see
if I can figure out what screwed up.

Thanks,
Rusty.
