Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751484Ab2JLUBa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Oct 2012 16:01:30 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:33117 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750873Ab2JLUB3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Oct 2012 16:01:29 -0400
Message-ID: <1350072088.26909.3.camel@joe-AO722>
Subject: Re: Spurious warning in checkpatch.pl?
From: Joe Perches <joe@perches.com>
To: Larry Finger <Larry.Finger@lwfinger.net>
Cc: Andy Whitcroft <apw@canonical.com>, LKML <linux-kernel@vger.kernel.org>
Date: Fri, 12 Oct 2012 13:01:28 -0700
In-Reply-To: <50787432.8030805@lwfinger.net>
References: <5078603C.9010709@lwfinger.net>
	 <1350067114.2243.35.camel@joe-AO722> <50787432.8030805@lwfinger.net>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.0-0ubuntu3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2012-10-12 at 14:49 -0500, Larry Finger wrote:
> One more question. Was the warning below intended?
> 
> WARNING: networking block comments put the trailing */ on a separate line
> #1846: FILE: drivers/net/wireless/rtlwifi/rtl8723ae/hal_btc.h:27:
> + *****************************************************************************/
> 
> To me, that line at the end of a copyright block looks better then
> 
> 
>   ****************************************************************************
>   */

No, not really.  It's a side effect of the nominal block comment
style that networking uses.

Maybe it could be improved by ignoring lines that end in "**/"
(\*\*\/\s*$) too.

