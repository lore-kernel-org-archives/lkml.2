Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757659Ab0EUUVb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 May 2010 16:21:31 -0400
Received: from mail.perches.com ([173.55.12.10]:2390 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752861Ab0EUUVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 May 2010 16:21:30 -0400
Subject: Re: [PATCH] get_maintainer.pl: improve config-file support
From: Joe Perches <joe@perches.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Florian Mickler <florian@mickler.org>,
       Stephen Hemminger <shemminger@vyatta.com>, linux-kernel@vger.kernel.org
In-Reply-To: <20100521131303.ad40e6d8.akpm@linux-foundation.org>
References: <1273698720-4010-1-git-send-email-florian@mickler.org>
	 <1273703333.20514.392.camel@Joe-Laptop.home>
	 <20100513095652.34aea727@schatten.dmk.lab>
	 <20100520084615.6e2efa38@schatten.dmk.lab>
	 <20100521131303.ad40e6d8.akpm@linux-foundation.org>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 21 May 2010 13:21:28 -0700
Message-ID: <1274473288.8140.569.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2010-05-21 at 13:13 -0700, Andrew Morton wrote:
> On Thu, 20 May 2010 08:46:15 +0200
> Florian Mickler <florian@mickler.org> wrote:
> > What's the status of this patch?
> > Do you take it, or do you have an issue with it? This is a clear
> > improvement in my opinion.
> Joe didn't sound very excited about it.
> If we're going to do this, we should hurry up, please - it'd be silly
> to introduce a config file and then change its format shortly
> afterwards.

If an ".ini" style config is used, I think it'd be better to
put this stuff in .git/config under a proper section so that
any checking style script (checkpatch, smatch, smpl, etc)
has a standard place to put stuff.

I think what I posted requires less overall work and doesn't
need updating every time a new option is added, but overall
the capability isn't all that necessary.

