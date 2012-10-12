Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932769Ab2JLSii (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 14:38:38 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:42731 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753808Ab2JLSih (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 14:38:37 -0400
Message-ID: <1350067114.2243.35.camel@joe-AO722>
Subject: Re: Spurious warning in checkpatch.pl?
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Oct 2012 11:38:34 -0700
In-Reply-To: <5078603C.9010709@lwfinger.net>
References: <5078603C.9010709@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 13:23 -0500, Larry Finger wrote:
> Andy,
> 
> The checkpatch.pl version in mainline is issuing what I think are false warnings 
> of the type
> 
> WARNING: networking block comments put the trailing */ on a separate line
> #93: FILE: drivers/net/wireless/rtlwifi/wifi.h:208:
> +       u32 rf_rb;              /* rflssi_readback */
> 
> Is a trailing comment for the member of a struct not allowed?

It's allowed.  Maybe even better, encouraged.

It's a change I made in commit 058806007450
("checkpatch: check networking specific block comment style")
without sufficient testing.

I'll see about fixing it.


