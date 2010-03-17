Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752448Ab0CQPZh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Mar 2010 11:25:37 -0400
Received: from mail.perches.com ([173.55.12.10]:1731 "EHLO mail.perches.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752049Ab0CQPZg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Mar 2010 11:25:36 -0400
Subject: Re: checkpatch false positive
From: Joe Perches <joe@perches.com>
To: Richard Kennedy <richard@rsk.demon.co.uk>
Cc: Andy Whitcroft <apw@canonical.com>, lkml <linux-kernel@vger.kernel.org>
In-Reply-To: <1268823629.1999.9.camel@localhost>
References: <1268823629.1999.9.camel@localhost>
Content-Type: text/plain; charset="UTF-8"
Date: Wed, 17 Mar 2010 08:25:35 -0700
Message-ID: <1268839535.1652.43.camel@Joe-Laptop.home>
Mime-Version: 1.0
X-Mailer: Evolution 2.28.3 
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2010-03-17 at 11:00 +0000, Richard Kennedy wrote:
> I'm getting this error from checkpatch which is a false positive AFAICT.
> I don't see any other way to code this macro so maybe this rule
> shouldn't apply?.
> 
> 	ERROR: space prohibited before open square bracket '['
> 	#24: FILE: drivers/staging/wlan-ng/p80211wext.c:1685:
> 	+#define IW_IOCTL(x) [(x)-SIOCSIWCOMMIT]

While true that this is a false positive, hiding array indexing
brackets in a macro doesn't seem a good idea.

Maybe it'd be better to move the brackets to the use?


